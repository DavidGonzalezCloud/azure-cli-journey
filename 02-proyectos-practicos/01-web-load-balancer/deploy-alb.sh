# 1. DEFINICION ESTRUCTA DE VARIABLES

RG_NAME="rg-portafolio-alb"
LOCATION="eastus"
VNET_NAME="vnet-frontend"
SUBNET_NAME="snet-web"

# 2. CREACION DE UN GRUPO DE RECURSOS
echo "Creando Grupo de Recursos: $RG_NAME en la region $LOCATION..."
az group create \
  --name $RG_NAME \
  --location $LOCATION

# 3. Creacion de Vnet y la subred en un solo comando
echo "Desplando la Red Virtual ($VNET_NAME) y la Subred ($SUBNET_NAME)..."
az network vnet create \
  --resource-group $RG_NAME \
  --name $VNET_NAME \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefixes 10.0.1.0/24


# 4. Crear el Network Security Group (NSG)
echo "Creando el NSG para la capa web..."
az network nsg create \
    --resource-group $RG_NAME \
    --name nsg-web \
    --location $LOCATION 

# 5. Creamos la regla de firewall para permitir HTTP (port 80)

echo "Creando regla que permite trafico HTTP entrante..."
az network nsg rule create \
    --resource-group $RG_NAME \
    --nsg-name nsg-web \
    --name Allow-HTTP \
    --protocol tcp \
    --priority 100 \
    --destination-port-range 80 \
    --access Allow \
    --direction Inbound

# 6. Asociamos el NSG con la Subred.

echo "Asociamos el NSG con la Subred de los servidores web..."
az network vnet subnet update \
    --resource-group $RG_NAME \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --network-security-group nsg-web


# IMPORTANTE: CREAMOS EL NAT GATEWAY PARA QUE CUANDO LAS MAQUINAS VIRTUALES
# SE CREEN PUEDAN ACCEDER A INTERNET Y PUEDAN ACTUALIZAR EL OS E INSTALAR NGINX

# Definición de variables para el NAT Gateway
NAT_GW_NAME="ngw-prod-web"
NAT_PIP_NAME="pip-ngw-prod-web"

# 7. Provisionamos la IP publica para el NAT Gateway. (Debe ser Standard)
echo "Creando IP Publica para el NAT Gateway..."
az network public-ip create \
    --resource-group $RG_NAME \
    --name $NAT_PIP_NAME \
    --sku Standard \
    --allocation-method Static \
    --location $LOCATION

# 8. Desplegar el NAT gateway\
echo "Desplgando el NAT gateway..."
az network nat gateway create \
    --resource-group $RG_NAME \
    --name $NAT_GW_NAME \
    --public-ip-address $NAT_PIP_NAME \
    --location $LOCATION

# 9. Asociamos el NAT Gateway con la subnet wab existente.
echo "Asociando NAT Gateway con la Subred web..."
az network vnet subnet update \
    --resource-group $RG_NAME \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --nat-gateway $NAT_GW_NAME


# Definimos las variables para el Load Balancer
ALB_NAME="alb-prod-web"
ALB_PIP="pip-alb-web"

# 10. Creacion de la IP Publica Standar
echo "Creando la IP Publica Standar para el ALB..."
az network public-ip create \
  --resource-group $RG_NAME \
  --name $ALB_PIP \
  --location $LOCATION \
  --allocation-method Static

# 11. Creacion de Azure Load Balancer
echo "Desplegando Azure Load Balancer $ALB_NAME..."
az network lb create \
  --resource-group $RG_NAME \
  --name $ALB_NAME \
  --sku Standard \
  --public-ip-address $ALB_PIP \
  --frontend-ip-name frontend-ip \
  --backend-pool-name backend-pool


# 12. Creacion del Health Probe (Sondeo de salud de cada servidor)
echo "Creando el health Probe en el puerto 80..."
az network lb probe create \
  --resource-group $RG_NAME \
  --lb-name $ALB_NAME \
  --name probe-http \
  --protocol tcp \
  --port 80 \
  --interval 10

# 13. Creacion de la regla de balanceo
echo "Creando Regla de Balanceo de Carga..."
az network lb rule create \
    --resource-group $RG_NAME \
    --lb-name $ALB_NAME \
    --name rule-http \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name frontend-ip \
    --probe-name probe-http \
    --disable-outbound-snat true



# 14. Creamos dos Network Interface Card.
# El bucle for ejecutara todo el bloque dos veces.
# En la primera vuelta la variable $i valdra 1. En la segunda vuelta la variable $i valdra 2.

for i in 1 2; do

    echo "Creando Tarjeta de Red (NIC) para el servidor 0$i..."
    az network nic create \
        --resource-group $RG_NAME \
        --name nic-web-0$i \
        --vnet-name $VNET_NAME \
        --subnet $SUBNET_NAME \
        --lb-name $ALB_NAME \
        --lb-address-pools backend-pool

done

# Creamos variable para mantener tener maquinas virutales de bajo costo.
VM_SIZE="Standard_B1s"

# 15. Creamos dos maquinas virtuales para el backend.

for i in 1 2; do

    echo "Creando Maquina Virtual(VM) vm-web-0$i en la Zona $i..."
    az vm create \
        --resource-group $RG_NAME \
        --name vm-web-0$i \
        --nics nic-web-0$i \
        --size $VM_SIZE \
        --image Ubuntu2204 \
        --admin-username azureuser \
        --generate-ssh-keys \
        --custom-data ./config/cloud-init.yaml \
        --zone $i \
        --no-wait

done


# 10. Creamos un Network Security Group para permitir trafico a las  VM.






