<#
.SYNOPSIS
    Script Nivel Producción para crear un usuario en Entra ID (Prueba de Aislamiento).
#>

Write-Host "Iniciando prueba de aislamiento de variables..." -ForegroundColor Cyan

# 1. Declaramos la contraseña directamente (Evitamos el bug de la terminal)
$PlainTextPassword = "AzUr3.L4b#2026!"

# 2. Conectarnos EXPLÍCITAMENTE a tu tenant corporativo
Write-Host "Conectando al tenant cloudjourney.me..." -ForegroundColor Cyan
Connect-MgGraph -TenantId "cloudjourney.me" -Scopes "User.ReadWrite.All" -UseDeviceAuthentication

# 3. Construir el Payload
$UserBody = @{
    # --- IDENTIDAD BÁSICA ---
    displayName       = "Samuel Jackson"
    userPrincipalName = "sjackson@cloudjourney.me"
    mailNickname      = "sjackson"
    givenName         = "Samuel"
    surname           = "Jackson"
    usageLocation     = "US"
    accountEnabled    = $true
    passwordProfile   = @{
        password                      = $PlainTextPassword
        forceChangePasswordNextSignIn = $true
    }

    # --- JOB INFORMATION (Información Laboral) ---
    jobTitle          = "Cloud Architect"
    department        = "Engineering"
    companyName       = "Cloud Journey Inc"
    employeeId        = "EMP-001"
    employeeType      = "Regular" # Puede ser Regular, Contractor, Guest, etc.
    officeLocation    = "Sede Principal - Nivel 3"

    # --- CONTACT INFORMATION (Información de Contacto) ---
    streetAddress     = "123 Innovation Drive"
    city              = "Seattle"
    state             = "WA" # Estado o Provincia
    postalCode        = "98101"
    country           = "United States"
    mobilePhone       = "+1 555-010-9999"
}

# 4. Crear el usuario
Write-Host "Inyectando el payload en Graph API..." -ForegroundColor Yellow

try {
    $NewUser = New-MgUser -BodyParameter $UserBody
    Write-Host "¡ÉXITO TOTAL! Usuario creado con ID Object: $($NewUser.Id)" -ForegroundColor Green
}
catch {
    Write-Host "Error detallado del servidor:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}