# original script from https://github.com/meetrevision/playbook/blob/main/src/Executables/EDGE.ps1

# Changes: removed unused functions and switches

param (   
    [Parameter(Mandatory = $true)]
    [ValidateSet("EdgeBrowser", "WebView", "EdgeUpdate")]
    [string]$Mode
)

function Uninstall-Process {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    $originalNation = [microsoft.win32.registry]::GetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', [Microsoft.Win32.RegistryValueKind]::String)

    # Set Nation to 84 (France) temporarily
    [microsoft.win32.registry]::SetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', 84, [Microsoft.Win32.RegistryValueKind]::String) | Out-Null
    
    # credits to he3als for the Acl commands
    $fileName = "IntegratedServicesRegionPolicySet.json"
    $pathISRPS = [Environment]::SystemDirectory + "\" + $fileName
    $aclISRPS = Get-Acl -Path $pathISRPS
    $aclISRPSBackup = [System.Security.AccessControl.FileSecurity]::new()
    $aclISRPSBackup.SetSecurityDescriptorSddlForm($acl.Sddl)
    if (Test-Path -Path $pathISRPS) {
        try {
            $admin = [System.Security.Principal.NTAccount]$(New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount]).Value
        
            $aclISRPS.SetOwner($admin)
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admin, 'FullControl', 'Allow')
            $aclISRPS.AddAccessRule($rule)
            Set-Acl -Path $pathISRPS -AclObject $aclISRPS
        
            Rename-Item -Path $pathISRPS -NewName ($fileName + '.bak') -Force
        }
        catch {
            Write-Error "[$Mode] Failed to set owner for $pathISRPS"
        }	
    }
    
    $baseKey = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate'
    $registryPath = $baseKey + '\ClientState\' + $Key

    if (!(Test-Path -Path $registryPath)) {
        Write-Host "[$Mode] Registry key not found: $registryPath"
        return
    }

    Remove-ItemProperty -Path $registryPath -Name "experiment_control_labels" -ErrorAction SilentlyContinue | Out-Null

    $uninstallString = (Get-ItemProperty -Path $registryPath).UninstallString
    $uninstallArguments = (Get-ItemProperty -Path $registryPath).UninstallArguments

    if ([string]::IsNullOrEmpty($uninstallString) -or [string]::IsNullOrEmpty($uninstallArguments)) {
        Write-Host "[$Mode] Cannot find uninstall methods for $Mode"
        return
    }

    $uninstallArguments += " --force-uninstall --delete-profile"

    # $uninstallCommand = "`"$uninstallString`"" + $uninstallArguments
    if (!(Test-Path -Path $uninstallString)) {
        Write-Host "[$Mode] setup.exe not found at: $uninstallString"
        return
    }
    Start-Process -FilePath $uninstallString -ArgumentList $uninstallArguments -Wait -NoNewWindow -Verbose

    # Restore Acl
    if (Test-Path -Path ($pathISRPS + '.bak')) {
        Rename-Item -Path ($pathISRPS + '.bak') -NewName $fileName -Force
        Set-Acl -Path $pathISRPS -AclObject $aclISRPSBackup
    }

    # Restore Nation
    [microsoft.win32.registry]::SetValue('HKEY_USERS\.DEFAULT\Control Panel\International\Geo', 'Nation', $originalNation, [Microsoft.Win32.RegistryValueKind]::String) | Out-Null

    if ((Get-ItemProperty -Path $baseKey).IsEdgeStableUninstalled -eq 1) {
        Write-Host "[$Mode] Edge Stable has been successfully uninstalled"
    } 
}

function Uninstall-Edge {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" -Name "NoRemove" -ErrorAction SilentlyContinue | Out-Null
   
    [microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev", "AllowUninstall", 1, [Microsoft.Win32.RegistryValueKind]::DWord) | Out-Null

    Uninstall-Process -Key '{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}'
    
    @( "$env:ProgramData\Microsoft\Windows\Start Menu\Programs",
        "$env:PUBLIC\Desktop",
        "$env:USERPROFILE\Desktop" ) | ForEach-Object {
        $shortcutPath = Join-Path -Path $_ -ChildPath "Microsoft Edge.lnk"
        if (Test-Path -Path $shortcutPath) {
            Remove-Item -Path $shortcutPath -Force
        }
    }

}

switch ($Mode) {
    "EdgeBrowser" { Uninstall-Edge }
    default { Write-Host "Invalid mode: $Mode" }
}