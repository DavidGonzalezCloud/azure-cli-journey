#Identificamos al grupo
$grupo = Get-MgGroup -Filter "DisplayName eq 'CloudEngineers'"

#Imprimimos el ID del grupo
Write-Host "ID del grupo: $($grupo.Id)" -ForegroundColor Blue

# Identificamos al usuario
$usuario = Get-MgUser -UserId "david.gonzalez@cloudjourney.me"

#Imprimimos el ID del usuario
Write-Host "ID del usuario: $($usuario.Id)" -ForegroundColor Blue

# Lo removemos del grupo específico
Remove-MgGroupMemberByRef -GroupId $grupo.Id -DirectoryObjectId $usuario.Id

Write-Host "Usuario removido del grupo." -ForegroundColor Green
