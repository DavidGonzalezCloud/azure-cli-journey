# ==========================================
# FASE 1: VARIABLES Y RED BASE
# ==========================================
RG_NAME="rg-vmss-lab"
LOCATION="eastus"
VNET_NAME="vnet-vmss"
SUBNET_NAME="snet-vmss"
PIP_NAME="pip-vmss-alb"
ALB_NAME="alb-vmss"
BE_POOL_NAME="bepool-vmss"
PROBE_NAME="probe-http"
RULE_NAME="rule-http"


# 1. Creación del Grupo de Recursos
echo -e "\e[34mCreando Resource Group...\e[0m"
az group create \
    --name $RG_NAME \
    --location $LOCATION

# 2. Creación de la Red Virtual (VNet) y Subred
echo -e "\e[34mCreando VNet y Subred...\e[0m"
az network vnet create \
  --resource-group $RG_NAME \
  --name $VNET_NAME \
  --address-prefixes 10.2.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefixes 10.2.1.0/24

# ==========================================
# FASE 2: LOAD BALANCER (EL DIRECTOR DE ORQUESTA)
# ==========================================

# 3. IP Pública (Requisito: SKU Standard para VMSS)
echo -e "\e[34mCreando IP Pública...\e[0m"
az network public-ip create \
  --resource-group $RG_NAME \
  --name $PIP_NAME \
  --sku Standard \
  --allocation-method Static


# 4. Creación del Load Balancer y un Backend Pool VACÍO
echo -e "\e[34mCreando Load Balancer...\e[0m"
az network lb create \
  --resource-group $RG_NAME \
  --name $ALB_NAME \
  --sku Standard \
  --public-ip-address $PIP_NAME \
  --frontend-ip-name frontend-ip \
  --backend-pool-name $BE_POOL_NAME

# 5. Sondeo de Salud (Health Probe)
echo -e "\e[34mConfigurando Health Probe (Puerto 80)...\e[0m"
az network lb probe create \
  --resource-group $RG_NAME \
  --lb-name $ALB_NAME \
  --name $PROBE_NAME \
  --protocol tcp \
  --port 80

# 6. Regla de Balanceo de Carga
echo -e "\e[34mCreando Regla de Balanceo...\e[0m"
az network lb rule create \
  --resource-group $RG_NAME \
  --lb-name $ALB_NAME \
  --name $RULE_NAME \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name frontend-ip \
  --backend-pool-name $BE_POOL_NAME \
  --probe-name $PROBE_NAME \
  --disable-outbound-snat true


# ==========================================
# FASE 3: VIRTUAL MACHINE SCALE SET (VMSS)
# ==========================================
VMSS_NAME="vmss-frontend"

echo -e "\e[34mDesplegando Cluster VMSS (2 Nodos Base)...\e[0m"
az vmss create \
    --resource-group $RG_NAME \
    --name $VMSS_NAME \
    --image Ubuntu2204 \
    --vm-sku Standard_B1s \
    --instance-count 2 \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --lb $ALB_NAME \
    --backend-pool-name $BE_POOL_NAME \
    --generate-ssh-keys

# ==========================================
# FASE 4: REGLAS DE AUTOESCALADO ELÁSTICO
# ==========================================

# 1. Crear el Perfil de Autoescalado y definir los Límites (Min 2, Max 5)
echo -e "\e[34mCreando Perfil de Autoescalado (Min: 2, Max: 5)...\e[0m"
az monitor autoscale create \
    --resource-group $RG_NAME \
    --resource $VMSS_NAME \
    --resource-type Microsoft.compute/virtualMachineScaleSets \
    --name "autoscale-perfil-web" \
    --min-count 2 \
    --max-count 5 \
    --count 2

# 2. Regla de Scale-Out (Crear máquinas cuando hay fuego)
# Si la CPU promedio es mayor al 75% durante 5 minutos, agrega 1 instancia.
echo -e "\e[34mConfigurando regla de Scale-Out (CPU > 75%)...\e[0m"
az monitor autoscale rule create \
    --resource-group $RG_NAME \
    --autoscale-name "autoscale-perfil-web" \
    --condition "Percentage CPU > 75 avg 5m" \
    --scale out 1 \
    --cooldown 5

# 3. Regla de Scale-In (Destruir máquinas para ahorrar dinero)
# Si la CPU promedio es menor al 25% durante 5 minutos, destruye 1 instancia.
echo -e "\e[34mConfigurando regla de Scale-In (CPU < 25%)...\e[0m"
az monitor autoscale rule create \
    --resource-group $RG_NAME \
    --autoscale-name "autoscale-perfil-web" \
    --condition "Percentage CPU < 25 avg 5m" \
    --scale in 1 \
    --cooldown 5


# ==========================================
# FASE 5: SEGURIDAD Y DESPLIEGUE DE APLICACIÓN
# ==========================================

# 1. Crear el Network Security Group (NSG) y Regla HTTP
echo -e "\e[34mConfigurando Seguridad Perimetral (NSG)...\e[0m"
az network nsg create \
    --resource-group $RG_NAME \
    --name "nsg-vmss"

az network nsg rule create \
    --resource-group $RG_NAME \
    --nsg-name "nsg-vmss" \
    --name "HTTP-ALLOW" \
    --priority 100 \
    --destination-port-range 80 \
    --protocol tcp \
    --access Allow

# 2. Asociar el NSG a nuestra Subred
az network vnet subnet update \
    --resource-group $RG_NAME \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --network-security-group "nsg-vmss"


# 3. Actualizar la Plantilla Maestra del VMSS con el cloud-init
echo -e "\e[34mInyectando cloud-init en el modelo del VMSS...\e[0m"
az vmss update \
    --resource-group $RG_NAME \
    --name $VMSS_NAME \
    --custom-data ./config/cloud-init.yaml

# 4. Forzar la actualización (Upgrade) de las instancias encendidas
echo -e "\e[34mActualizando las instancias existentes (esto las reiniciará)...\e[0m"
az vmss update-instances \
    --resource-group $RG_NAME \
    --name $VMSS_NAME \
    --instance-ids "*"





