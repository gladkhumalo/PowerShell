# Day 007 - Process Manager


Write-Host "        Process Manager            " -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

Write-Host "`nTop 10 Processes by Memory Usage`n" -ForegroundColor Yellow

Get-Process |
Sort-Object WorkingSet -Descending |
Select-Object -First 10 `
    Name,
    Id,
    @{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet / 1MB,2)}} |
Format-Table -AutoSize

$ProcessName = Read-Host "`nEnter the name of a process to stop (or press Enter to skip)"

if (![string]::IsNullOrWhiteSpace($ProcessName))
{
    try
    {
        $Process = Get-Process -Name $ProcessName -ErrorAction Stop

        Write-Host ""
        Write-Host "Process found:" -ForegroundColor Green
        $Process | Select-Object Name, Id

        $Confirm = Read-Host "Are you sure you want to stop this process? (Y/N)"

        if ($Confirm -eq "Y")
        {
            $Process | Stop-Process -Force

            Write-Host ""
            Write-Host "Process stopped successfully." -ForegroundColor Green
        }
        else
        {
            Write-Host ""
            Write-Host "Operation cancelled."
        }
    }
    catch
    {
        Write-Host ""
        Write-Host "Process not found." -ForegroundColor Red
    }
}
else
{
    Write-Host ""
    Write-Host "No process selected."
}