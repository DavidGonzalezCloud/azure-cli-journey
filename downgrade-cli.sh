    # 1. Remover la versión actual (inestable)
echo -e "\e[33mDesinstalando la versión actual de Azure CLI...\e[0m"
sudo apt-get remove -y azure-cli

# 2. Instalar la versión específica 2.82.0 para Noble Numbat
echo -e "\e[34mInstalando Azure CLI versión 2.82.0...\e[0m"
sudo apt-get update
sudo apt-get install -y azure-cli=2.82.0-1~noble

# 3. Bloquear la versión para evitar actualizaciones automáticas futuras
echo -e "\e[32mAplicando 'hold' para prevenir actualizaciones automáticas...\e[0m"
sudo apt-mark hold azure-cli

# 4. Verificar la instalación
echo -e "\e[36mVerificando la versión instalada...\e[0m"
az --version
    
# Sospechosamente este linea si funciono y la re arriba no.   
sudo apt-get install -y azure-cli=2.82.0-1~noble