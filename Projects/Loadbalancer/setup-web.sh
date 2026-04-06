
#!/bin/bash
# 1. Actualizar repositorios e instalar Nginx
sudo apt-get update
sudo apt-get install -y nginx

# 2. Inyectar el diseño web con tu paleta de colores corporativa
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<body style="background-color: #F8F9FA; color: #212529; font-family: sans-serif; text-align: center; padding-top: 100px;">
  <h1>Cloud Journey</h1>
  <h2>Infraestructura de Alta Disponibilidad</h2>
  <p>Respondiendo exitosamente desde el servidor: <strong style="color: #0078D4;">$(hostname)</strong></p>
  <div style="background-color: #0078D4; color: white; padding: 15px; display: inline-block; border-radius: 8px; font-weight: bold; margin-top: 20px;">
    Trafico enrutado por Azure ALB
  </div>
  <footer style="margin-top: 80px; color: #0B1120;">
    <span style="color: #00BCF2;">&#9632;</span> Nodo Activo
  </footer>
</body>
</html>
EOF

# 3. Asegurar que el servicio esté corriendo
sudo systemctl restart nginx