# Buscamos el grupo
$grupo = Get-MgGroup -Filter "DisplayName eq 'CloudEngineer'"

#Actualizar nombre de grupo
Update-MgGroup -GroupId $grupo.Id -DisplayName "CloudEngineers"

#Imprimimos que se actualizado el nombre del grupo correctamente
Write-Host 'Nombre del grupo actualizado correctamente' -ForegroundColor Blue

# Actualizamos la descripción
Update-MgGroup -GroupId $grupo.Id -Description "Nuevo grupo de trabajo de cloud engineer de Azure"

#imprimimos que se actualizo correctamente la descripcion del grupo.
Write-Host 'Descripcion del grupo actualizada correctamente' -ForegroundColor Blue

Write-Host "Propiedades actualizadas correctamente." -ForegroundColor Green