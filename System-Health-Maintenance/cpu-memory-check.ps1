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

