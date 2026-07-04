# Day 002 - Windows Service Health Checker

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "     Service Health Checker        " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Define critical services (you can expand this later)
$CriticalServices = @(
    "wuauserv",   # Windows Update
    "bits",       # Background Intelligent Transfer Service
    "Winmgmt",    # Windows Management Instrumentation
    "EventLog",   # Windows Event Log
    "Spooler"     # Print Spooler
)

Write-Host "`nChecking critical services..." -ForegroundColor Yellow

$ServiceReport = foreach ($service in $CriticalServices) {

    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue

    if ($null -eq $svc) {
        [PSCustomObject]@{
            ServiceName = $service
            Status      = "NOT FOUND"
            Health      = "UNKNOWN"
        }
    }
    else {
        [PSCustomObject]@{
            ServiceName = $svc.Name
            Status      = $svc.Status
            Health      = if ($svc.Status -eq "Running") { "OK" } else { "CRITICAL" }
        }
    }
}

# Display results
$ServiceReport | Format-Table -AutoSize

# Highlight issues
$Problems = $ServiceReport | Where-Object { $_.Health -ne "OK" }

Write-Host "`nSummary:" -ForegroundColor Green
Write-Host "Total Services Checked: $($ServiceReport.Count)"
Write-Host "Problems Found: $($Problems.Count)" -ForegroundColor Red

# Export report
$ServiceReport | Export-Csv ".\service-health-report.csv" -NoTypeInformation

Write-Host "`nReport exported to service-health-report.csv" -ForegroundColor Yellow