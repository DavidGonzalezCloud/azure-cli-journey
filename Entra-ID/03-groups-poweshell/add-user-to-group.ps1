# 1. Buscamos el usuario mediante su UPN (reemplaza con un correo válido de tu tenant)
$usuario = Get-MgUser -UserId "david.gonzalez@cloudjourney.me"

#Imprimimos el ID del usuario para verificar que es el correcto
Write-Host $usuario.Id -ForegroundColor Blue

#Buscamos el id del grupo al que queremos agregar el usuario.
$grupo = Get-MgGroup -Filter "DisplayName eq 'CloudEngineers'"

#Imprimimos el ID del grupo para verificar que es el correcto
Write-Host $grupo.Id -ForegroundColor Blue

# 2. Ejecutamos la asignación vinculando el ID del grupo y el ID del usuario
New-MgGroupMember -GroupId $grupo.Id -DirectoryObjectId $usuario.Id

Write-Host "Usuario asignado correctamente al grupo." -ForegroundColor Green