<#
.SYNOPSIS
    Script definitivo para la creación masiva de usuarios en Entra ID.
.DESCRIPTION
    Lee un archivo CSV limpio, construye el payload dinámicamente y 
    crea los usuarios iterando con un bucle foreach. Aísla errores por usuario.
#>

Write-Host "Iniciando Laboratorio de Despliegue Masivo..." -ForegroundColor Cyan

# 1. Definir la ruta del archivo CSV (Asegúrate de que el nombre coincida)
$csvPath = ".\users_bulk.csv"

# Validar que el archivo realmente exista antes de hacer nada
if (-not (Test-Path $csvPath)) {
    Write-Host "Error fatal: No se encontró el archivo CSV en la ruta especificada." -ForegroundColor Red
    return
}

# Cargar los datos a la memoria
$usuarios = Import-Csv -Path $csvPath

# 2. Conexión explícita al Tenant
Write-Host "Conectando al tenant cloudjourney.me..." -ForegroundColor Cyan
Connect-MgGraph -TenantId "cloudjourney.me" -Scopes "User.ReadWrite.All" -UseDeviceAuthentication

Write-Host "Iniciando inyección de identidades..." -ForegroundColor Yellow

# 3. El Bucle (Iteración por cada fila del CSV)
foreach ($user in $usuarios) {
    
    Write-Host "Procesando: $($user.UserPrincipalName)..." -NoNewline
    
    # Construir el Payload dinámicamente mapeando las columnas del CSV
    $UserBody = @{
        displayName       = $user.DisplayName
        userPrincipalName = $user.UserPrincipalName
        mailNickname      = $user.MailNickname
        givenName         = $user.GivenName
        surname           = $user.Surname
        usageLocation     = $user.UsageLocation
        accountEnabled    = $true
        passwordProfile   = @{
            password                      = $user.Password
            forceChangePasswordNextSignIn = $true
        }
        jobTitle          = $user.JobTitle
        department        = $user.Department
        companyName       = $user.CompanyName
        employeeId        = $user.EmployeeId
        officeLocation    = $user.OfficeLocation
        streetAddress     = $user.StreetAddress
        city              = $user.City
        state             = $user.State
        postalCode        = $user.PostalCode
        country           = $user.Country
        mobilePhone       = $user.MobilePhone
        # Aplicamos el casteo estricto [string[]] que aprendimos en el paso anterior
        businessPhones    = [string[]]@($user.BusinessPhone) 
    }

    try {
        # Intentar crear el usuario
        $NewUser = New-MgUser -BodyParameter $UserBody
        Write-Host " [ÉXITO] ID: $($NewUser.Id)" -ForegroundColor Green
    }
    catch {
        # Si este usuario falla, el script NO se detiene, solo muestra el error y sigue con el próximo
        Write-Host " [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Despliegue masivo finalizado." -ForegroundColor Cyan
# Disconnect-MgGraph # Opcional: Cerrar la sesión por seguridad al terminar