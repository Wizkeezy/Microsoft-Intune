#Values to search for in the DisplayName value
$targetValues = "Gmail", "Hojas de calculo", "Google Drive", "Youtube", "Documentos", "Presentaciones"

#Search on all subkeys in HKEY_USERS
$usersPath = "Registry::HKEY_USERS"
$users = Get-ChildItem -Path $usersPath | Where-Object { $_.PSChildName -match "S-1-12-1-\d+-\d+-\d+-\d+" }

foreach ($user in $users) {
    $profilePath = Join-Path -Path $user.PSPath -ChildPath "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

    if (Test-Path -Path $profilePath) {
        #Get the subkeys inside \Uninstall key
        $subKeys = Get-ChildItem -Path $profilePath
 
        foreach ($subKey in $subKeys) {
            $registryKey = Get-Item -LiteralPath $subKey.PSPath

             #Check if the value DisplayName exists in the key
            if ($registryKey.PSObject.Properties.Match('DisplayName')) {
                $displayName = $registryKey.GetValue('DisplayName')

                 if ($displayName -in $targetValues) {
                    Write-Host "Se encontró DisplayName: '$displayName' en $($subKey.PSChildName) del perfil de usuario $($user.PSChildName)"

                    #Deleting registry key
                    Remove-Item -LiteralPath $subKey.PSPath -Force
                }
            }
        }
    }
}

#Deleting home menu folder
$usuarios = Get-ChildItem -Path 'C:\Users' -Directory

foreach ($usuario in $usuarios) {
    $rutaUsuario = Join-Path -Path $usuario.FullName -ChildPath 'AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Aplicaciones de Chrome'

    if (Test-Path -Path $rutaUsuario -PathType Container) {
        Remove-Item -Path $rutaUsuario -Recurse -Force
    }
}