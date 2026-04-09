# 🚀 Proyecto 02: Servidor Web Seguro con Almacenamiento Desacoplado (Azure CLI)

Bienvenido al segundo proyecto práctico de mi **Cloud Journey**. En este laboratorio, desplegamos una arquitectura de Infraestructura como Servicio (IaaS) lista para producción, separando el cómputo del almacenamiento e implementando automatización de arranque.

## 📐 Arquitectura del Proyecto

Este proyecto provisiona un servidor web autónomo en Azure con las siguientes características:
* **Red Segura:** Virtual Network y Subnet aisladas con IP Pública estática.
* **Seguridad Perimetral (NSG):** Reglas de firewall limitadas por el principio de menor privilegio (solo HTTP 80 y SSH 22).
* **Cómputo Automatizado:** Máquina Virtual Ubuntu (`Standard_B2s`) aprovisionada mediante `cloud-init` para instalar Apache automáticamente.
* **Almacenamiento Desacoplado:** Disco del Sistema Operativo (`StandardSSD_LRS`) separado del Disco de Datos (`Premium_LRS` - P3 de 16GB) para garantizar rendimiento y persistencia.

## 📂 Estructura del Repositorio

La separación de la configuración y la ejecución es una buena práctica de ingeniería:

```text
02-azure-vm-datadisk/
│
├── config/
│   └── cloud-init.yaml   # Script de bootstrapping para instalar Apache
├── deploy.sh             # Script principal de Bash con comandos de Azure CLI
└── README.md             # Documentación del proyecto