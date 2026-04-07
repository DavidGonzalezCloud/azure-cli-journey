# Si cloud-init.yaml no funciona, con esta inyeccion
# podremos actualizar el OS e instalar Nginx.

for i in 1 2; do
  echo "Inyectando configuración web en vm-web-0$i..."
  az vm run-command invoke \
    --resource-group rg-portfolio-alb \
    --name vm-web-0$i \
    --command-id RunShellScript \
    --scripts @setup-web.sh
done