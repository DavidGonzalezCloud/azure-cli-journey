# 1. Crear el grupo de recursos adonde se alojara toda la Infraestructura.
echo "CREANDO GRUPO DE RECURSOS" 
az group create \
    --name ProyectoWeb-RG \
    --location eastus


# 2. Crear la Vnet y la Subnet.
echo "CREANDO VIRTUAL NETWORK Y SUBNET"
az network vnet create \
    --resource-group ProyectoWeb-RG \
    --name WebVNet \
    --address-prefix 10.0.0.0/16 \
    --subnet-name WebSubnet \
    --subnet-prefix 10.0.1.0/24

# 3. Crear una Public IP.
echo "CREANDO DIRECCION DE IP PUBLICA"
az network public-ip create \
    --resource-group ProyectoWeb-RG \
    --name WebPublicIP \
    --sku Standard \
    --allocation-method Static

#4. Crear un Network Security Group
echo "CREANDO NETWORK SECURITY GROUP"
az network nsg create \
    --resource-group ProyectoWeb-RG \
    --name WebNSG

#5. Crear regla en el NSG para permitir tráfico Web (HTTP - Puerto 80)
echo "CREANDO REGLA EN NSG PARA PERMITIR TRAFICO HTTP EN PUERTO 80"
az network nsg rule create \
    --resource-group ProyectoWeb-RG \
    --nsg-name WebNSG \
    --name Allow-HTTP \
    --priority 100 \
    --destination-port-range 80 \
    --access Allow \
    --protocol Tcp

#6. Crear regla en el NSG para permitir administración (SSH - Puerto 22)
echo "CREANDO REGLA EN NSG PARA PERMITIR CONECXION CON SSH"
az network nsg rule create \
    --resource-group ProyectoWeb-RG \
    --nsg-name WebNSG \
    --name Allow-SSH \
    --priority 110 \
    --destination-port-range 22 \
    --access Allow \
    --protocol Tcp

# 7. Crear una VM
echo "CREANDO MAQUINA VIRTUAL"
az vm create \
    --resource-group ProyectoWeb-RG \
    --name WebServer-VM \
    --image Ubuntu2204 \
    --size Standard_B2s \
    --vnet-name WebVNet \
    --subnet WebSubnet \
    --public-ip-address WebPublicIP \
    --nsg WebNSG \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data ./config/cloud-init.yaml \
    --os-disk-name WebServer-OS-Disk \
    --os-disk-size-gb 32 \
    --storage-sku StandardSSD_LRS

# 8. Creamos un nuevo disco dura para los datos
echo "CREANDO DISCO DURO PARA ALMACENAMIENTO DE DATOS"
az disk create \
    --resource-group ProyectoWeb-RG \
    --name DataDisk-01 \
    --sku Premium_LRS \
    --size-gb 8 \
    --tier P3 \
    --public-network-access Disabled \
    --network-access-policy DenyAll \
    --encryption-type EncryptionAtRestWithPlatformKey

# 9. Adjuntar el disco de datos con la VM existente.
echo "ADJUNTANDO NUEVO DISCO DE DATOS A MAQUINA VIRTUAL"
az vm disk attach \
    --resource-group ProyectoWeb-RG \
    --vm-name WebServer-VM \
    --name DataDisk-01 \
    --lun 0





