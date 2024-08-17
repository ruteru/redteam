$logFile = "C:\DefenderScanLog.txt"

Start-MpScan -ScanType QuickScan

while ((Get-MpPreference).IsScheduledScanRunning) {
    Start-Sleep -Seconds 10
}

$threats = Get-MpThreatDetection

if ($threats) {
    $threats | Out-File -FilePath $logFile -Append
    Write-Host "Amenazas detectadas. Consulta el log en $logFile"
} else {
    Write-Host "No se detectaron amenazas."
}