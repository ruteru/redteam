function Start-ThreatMitigation {
    Write-Host "Iniciando análisis rápido con Windows Defender..." -ForegroundColor Cyan

    Start-MpScan -ScanType QuickScan

    Write-Host "Análisis rápido completado." -ForegroundColor Green

    $threats = Get-MpThreat

    if ($threats) {
        Write-Host "Amenazas detectadas. Iniciando mitigación..." -ForegroundColor Yellow

        $threats | ForEach-Object {
            Remove-MpThreat -ThreatID $_.ThreatID
        }

        Write-Host "Mitigación completada. Se han eliminado las amenazas." -ForegroundColor Green
    } else {
        Write-Host "No se han detectado amenazas." -ForegroundColor Green
    }

    $logPath = "C:\DefenderMitigationLog.txt"
    Get-MpThreat | Out-File -FilePath $logPath -Append
    Write-Host "Log guardado en $logPath." -ForegroundColor Cyan
}

Perform-ThreatMitigation
