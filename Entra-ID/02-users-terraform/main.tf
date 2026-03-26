# 1. Configuración del Proveedor (Le decimos a Terraform qué API usar)
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0" # Es buena práctica fijar la versión
    }
  }
}

# Inicializamos el proveedor (usará las credenciales de 'az login')
provider "azuread" {}

# 2. Declaración del Recurso (El Usuario)
resource "azuread_user" "single_user" {
  user_principal_name   = "sjackson@cloudjourney.me"
  display_name          = "Samuel Jackson"
  mail_nickname         = "sjackson"
  password              = "Cloud.Journey.2026!*"
  force_password_change = true

  # Información Laboral
  job_title    = "Cloud Architect"
  department   = "Engineering"
  company_name = "Cloud Journey Inc"
  employee_id  = "EMP-001"

  # Información de Contacto
  usage_location = "US"
  city           = "Seattle"
  state          = "WA"
  country        = "United States"

}