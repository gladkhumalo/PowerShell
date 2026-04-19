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
