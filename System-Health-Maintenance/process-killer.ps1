# ==========================================
# process-killer.ps1
# Automatically kills high CPU processes
# ==========================================

# CONFIGURATION
$cpuThreshold = 300        # CPU time threshold
$excludedProcesses = @(
    "System",
    "Idle",
    "explorer",
    "svchost",
    "powershell"
)

# LOG FILE
$logFile = "$PSScriptRoot\process-killer.log"

# FUNCTION: Write Log
function Write-Log {
    param (
        [string]$message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

Write-Host "Scanning for high CPU processes..." -ForegroundColor Cyan

# GET PROCESSES
$processes = Get-Process | Sort-Object CPU -Descending

foreach ($process in $processes) {

    # Skip processes without CPU time
    if ($null -eq $process.CPU) {
        continue
    }

    # Skip excluded processes
    if ($excludedProcesses -contains $process.ProcessName) {
        continue
    }

    # Check threshold
    if ($process.CPU -gt $cpuThreshold) {

        Write-Host "`nHigh CPU Process Detected:" -ForegroundColor Yellow
        Write-Host "Name : $($process.ProcessName)"
        Write-Host "CPU  : $([math]::Round($process.CPU,2))"
        Write-Host "PID  : $($process.Id)"

        try {
            Stop-Process -Id $process.Id -Force

            $msg = "Killed process: $($process.ProcessName) (PID: $($process.Id)) CPU: $($process.CPU)"
            Write-Host "Process terminated." -ForegroundColor Red

            Write-Log $msg
        }
        catch {
            $errorMsg = "Failed to kill process: $($process.ProcessName) | $_"

            Write-Host $errorMsg -ForegroundColor DarkRed
            Write-Log $errorMsg
        }
    }
}

Write-Host "`nScan complete." -ForegroundColor Green