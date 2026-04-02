# 1. Buscamos el usuario y el grupo por sus nombres/correos
$usuario = Get-MgUser -UserId "david.gonzalez@cloudjourney.me"
$grupo   = Get-MgGroup -Filter "DisplayName eq 'CloudEngineers'"

# 2. Verificamos que ambos existan
if ($usuario -and $grupo) {
    
    # 3. Preparamos el parámetro del cuerpo (Body Parameter)
    # Graph necesita la URL completa del objeto del usuario
    $ownerParams = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($usuario.Id)"
    }

    # 4. Ejecutamos el comando para asignar el propietario
    New-MgGroupOwner -GroupId $grupo.Id -BodyParameter $ownerParams

    Write-Host "¡Éxito! $($usuario.DisplayName) ahora es Propietario de $($grupo.DisplayName)." -ForegroundColor Green
} else {
    Write-Host "Error: No se pudo encontrar el usuario o el grupo especificado." -ForegroundColor Red
}