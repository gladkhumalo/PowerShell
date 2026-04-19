# ============================
# CONFIGURATION
# ============================
$cpuThreshold = 80          # % CPU usage alert threshold
$interval = 5              # Seconds between checks
$topProcesses = 5          # Number of top processes to display

# ============================
# FUNCTION: Get CPU Usage
# ============================
function Get-CPUUsage {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    return [math]::Round($cpu.CounterSamples.CookedValue, 2)
}

# ============================
# FUNCTION: Get Memory Usage
# ============================
function Get-MemoryUsage {
    $os = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $used = [math]::Round($total - $free, 2)
    $percentUsed = [math]::Round(($used / $total) * 100, 2)

    return [PSCustomObject]@{
        TotalGB = $total
        UsedGB  = $used
        FreeGB  = $free
        UsagePercent = $percentUsed
    }
}

# ============================
# FUNCTION: Get Top Processes
# ============================
function Get-TopProcesses {
    Get-Process |
        Sort-Object CPU -Descending |
        Select-Object -First $topProcesses Name, CPU, PM
}

# ============================
# MAIN LOOP
# ============================
while ($true) {
    Clear-Host
    Write-Host "===== SYSTEM HEALTH CHECK =====" -ForegroundColor Cyan
    Write-Host "Time: $(Get-Date)" -ForegroundColor Gray

    # CPU
    $cpuUsage = Get-CPUUsage
    Write-Host "`nCPU Usage: $cpuUsage%" -ForegroundColor Yellow

    if ($cpuUsage -gt $cpuThreshold) {
        Write-Host "⚠ ALERT: High CPU Usage!" -ForegroundColor Red
    }

    # Memory
    $mem = Get-MemoryUsage
    Write-Host "`nMemory Usage:"
    Write-Host "Used: $($mem.UsedGB) GB / $($mem.TotalGB) GB ($($mem.UsagePercent)%)"

    # Top Processes
    Write-Host "`nTop $topProcesses Processes by CPU:"
    Get-TopProcesses | Format-Table -AutoSize

    Start-Sleep -Seconds $interval
}

