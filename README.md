# ☁️ Azure CLI Journey Labs

Este repositorio es una bitácora técnica y práctica que documenta mi aprendizaje y desarrollo de infraestructura como código utilizando la **Interfaz de Línea de Comandos de Azure (Azure CLI)**. 

> 🌐 **Tutoriales y Arquitectura Detallada:** Puedes encontrar la documentación completa, paso a paso, y el análisis teórico de estos proyectos en mi blog personal: **[Cloud Journey](https://cloudjourney.me)**.

El objetivo principal de este proyecto es construir una base de conocimiento escalable, pasando desde el aprovisionamiento de recursos atómicos hasta el despliegue de arquitecturas integrales complejas. Esta práctica constante está orientada a consolidar habilidades de administración en la nube y sirve como laboratorio para la preparación de certificaciones arquitectónicas y de administración (como la AZ-104 y AZ-305).

---

## 🏗️ Estructura del Repositorio

El repositorio está diseñado siguiendo el principio de "Separación de Intereses" (Separation of Concerns) y categorizado por los dominios de servicios oficiales de Azure:

### `01-recursos-base/`
Contiene scripts atómicos (`.azcli`) enfocados en operaciones CRUD (Crear, Leer, Actualizar, Borrar) para servicios individuales. Es el "diccionario" de comandos.
* **`/compute`**: Gestión de Máquinas Virtuales, discos, etc.
* **`/management`**: Gobernanza, Grupos de Recursos, validación de suscripciones.
* **`/networking`**: Redes Virtuales, IPs Públicas, Grupos de Seguridad de Red (NSG), Tarjetas de Red (NIC).

### `02-proyectos-practicos/`
Contiene integraciones y arquitecturas completas que combinan múltiples recursos base para resolver escenarios del mundo real. *(Para ver la teoría y el paso a paso explicativo de estos despliegues, visita [Cloud Journey](https://cloudjourney.me)).*
* **`01-web-load-balancer/`**: Despliegue de un balanceador de carga que distribuye tráfico entre múltiples máquinas virtuales con inyección de configuración mediante `cloud-init`.

---

## ⚙️ Prerrequisitos y Entorno

Para ejecutar los scripts de este repositorio de manera óptima, se recomienda el siguiente entorno:

* **Sistema Operativo:** Entorno Linux (desarrollado y probado específicamente en **Ubuntu 24.04.4 LTS**).
* **Herramienta Principal:** [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (Actualizado a la última versión).
* **Autenticación:** Una suscripción activa de Microsoft Azure (validar conexión con `az login`).
* **Editor:** Visual Studio Code con la extensión oficial de Azure CLI.

---

## 🔒 Consideraciones de Seguridad

Las mejores prácticas de seguridad son implementadas en este entorno de laboratorio:
* Ninguna credencial, token o contraseña se sube al control de versiones. 
* Se utiliza un archivo excluido mediante `.gitignore` para pruebas locales con datos sensibles.
* En los proyectos prácticos se fomenta el uso de Azure Key Vault o variables de entorno locales para la inyección de secretos durante el despliegue de la infraestructura.

---

*Documentando el viaje hacia la maestría en la nube.* 🚀