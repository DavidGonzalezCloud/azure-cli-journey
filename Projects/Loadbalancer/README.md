# ☁️ Implementación de Arquitectura Web de Alta Disponibilidad en Azure

Este repositorio contiene la Infraestructura como Código (IaC) en bash para desplegar un entorno web seguro, balanceado y tolerante a fallos en Microsoft Azure, utilizando la **Azure CLI**. 

Este proyecto forma parte de los laboratorios prácticos de **Cloud Journey**, demostrando la aplicación de mejores prácticas de la industria como Zero Trust, Alta Disponibilidad (HA) y automatización de servidores.

## 🏗️ Arquitectura del Proyecto

El script provisiona los siguientes recursos nativos de la nube:
- **Virtual Network (VNet) & Subnet:** Aislamiento lógico de la red.
- **Network Security Group (NSG):** Firewall de capa 4 aplicando el principio de mínimo privilegio (Zero Trust), permitiendo únicamente tráfico entrante por el puerto HTTP (80).
- **Azure NAT Gateway:** Proporciona salida segura a Internet (SNAT) para las máquinas virtuales privadas, permitiendo la descarga de actualizaciones sin exponerlas al tráfico público entrante.
- **Azure Load Balancer (Standard SKU):** Distribuye el tráfico entrante entre los nodos del backend. Incluye un *Health Probe* (TCP/80) y desactiva el SNAT saliente por diseño.
- **Virtual Machines (Ubuntu 22.04 LTS):** Dos servidores web desplegados en distintas **Zonas de Disponibilidad (Availability Zones 1 y 2)** para garantizar tolerancia a fallos del centro de datos físico.
- **Cloud-Init (Custom Data):** Automatización del despliegue del servidor web (Nginx) y la inyección del sitio estático al momento del arranque.

## 📁 Estructura de Archivos

* `deploy-alb.sh`: Script principal de bash que contiene toda la lógica de despliegue secuencial en Azure CLI.
* `cloud-init.yaml`: Archivo de configuración YAML que automatiza la instalación de Nginx y la personalización del HTML dentro de las máquinas virtuales.
* `setup-web.sh`: (Opcional) Script de remediación en sitio utilizado mediante `az vm run-command` para inyectar configuraciones post-despliegue si es necesario.

## 🚀 Prerrequisitos

Antes de ejecutar este proyecto, asegúrate de tener:
1. Una suscripción activa de Microsoft Azure.
2. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) instalado localmente.
3. Haber iniciado sesión en tu cuenta ejecutando `az login`.
4. Permisos de administrador sobre la suscripción para crear recursos de red y cómputo.

## ⚙️ Instrucciones de Despliegue

Sigue estos pasos para desplegar la infraestructura en tu entorno:

1. **Clonar el repositorio:**
   ```bash
   git clone <tu-url-del-repositorio>
   cd <nombre-de-la-carpeta>