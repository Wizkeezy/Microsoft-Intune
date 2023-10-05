# Valores a buscar en el valor DisplayName
$targetValues = "Gmail", "Hojas de cálculo", "Google Drive", "Youtube", "Documentos", "Presentaciones"

# Recorrer todas las subclaves en HKEY_USERS
$usersPath = "Registry::HKEY_USERS"
$users = Get-ChildItem -Path $usersPath | Where-Object { $_.PSChildName -match "S-1-12-1-\d+-\d+-\d+-\d+" }

foreach ($user in $users) {
    $profilePath = Join-Path -Path $user.PSPath -ChildPath "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

    if (Test-Path -Path $profilePath) {
        # Obtener las subclaves dentro de Uninstall
        $subKeys = Get-ChildItem -Path $profilePath
 
        foreach ($subKey in $subKeys) {
            $registryKey = Get-Item -LiteralPath $subKey.PSPath

             # Comprobar si el valor DisplayName existe en la clave
            if ($registryKey.PSObject.Properties.Match('DisplayName')) {
                $displayName = $registryKey.GetValue('DisplayName')

                 if ($displayName -in $targetValues) {
                    Write-Host "Se encontró DisplayName: '$displayName' en $($subKey.PSChildName) del perfil de usuario $($user.PSChildName)"

                    # Eliminar la clave de registro correspondiente
                    Remove-Item -LiteralPath $subKey.PSPath -Force
                }
            }
        }
    }
}

 

 

 

#borrado carpeta menu inicio
$usuarios = Get-ChildItem -Path 'C:\Users' -Directory

 

 

 

foreach ($usuario in $usuarios) {
    $rutaUsuario = Join-Path -Path $usuario.FullName -ChildPath 'AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Aplicaciones de Chrome'

 

 

 

    if (Test-Path -Path $rutaUsuario -PathType Container) {
        Remove-Item -Path $rutaUsuario -Recurse -Force
    }
}