#Primero tenemos que solicitar permisos espcificos para poder manejar los grupos y manejar usuarios.

Connect-MgGraph -Scopes "Group.ReadWrite.All", "User.Read.All"

# 1. Definimos los parámetros del grupo
$groupParams = @{
    DisplayName     = 'CloudEngineers'
    Description     = 'Grupo de seguridad para ingenieros Cloud de práctica AZ-104'
    MailEnabled     = $false
    SecurityEnabled = $true
    MailNickName    = 'az104engineers'
}

# 2. Creamos el grupo y almacenamos el resultado en una variable
$nuevoGrupo = New-MgGroup @groupParams

# 3. Verificamos en consola que el grupo se creó exitosamente
$nuevoGrupo | Format-List DisplayName, Id, Description