$logPath = "$PSScriptRoot\NonMicrosoftAppsLog.txt"

if (Test-Path $logPath) {
    Remove-Item $logPath -Force
}

$msiPackages = Get-WmiObject -Query "SELECT * FROM Win32_Product"

function Test-MicrosoftApp {
    param (
        [string]$vendor
    )
    return $vendor -match "Microsoft"
}

foreach ($package in $msiPackages) {
    if (-not (Test-MicrosoftApp -vendor $package.Vendor)) {
        Add-Content -Path $logPath -Value "App Name: $($package.Name)"
        Add-Content -Path $logPath -Value "Vendor: $($package.Vendor)"
        Add-Content -Path $logPath -Value "Version: $($package.Version)"
        Add-Content -Path $logPath -Value "----------------------------------------"
    }
}

$msuPackages = Get-ChildItem "C:\Windows\servicing\Packages\*.mum"

foreach ($msuPackage in $msuPackages) {
    $content = Get-Content -Path $msuPackage.FullName
    $isMicrosoft = $content -match "Microsoft"

    if (-not $isMicrosoft) {
        Add-Content -Path $logPath -Value "MSU Package: $($msuPackage.Name)"
        Add-Content -Path $logPath -Value "----------------------------------------"
    }
}

if (Test-Path $logPath) {
    Write-Host "Log de aplicaciones no-Microsoft guardado en: $logPath"
} else {
    Write-Host "No se encontraron aplicaciones no-Microsoft."
}
