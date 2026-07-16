# Day 001 - System Information Reporter

## Objective

Build a PowerShell script that gathers key system information from a Windows device and displays it in a readable format.

## Concepts Learned

* Variables
* Environment Variables
* PowerShell Cmdlets
* CIM Queries
* Select-Object
* Calculated Properties
* Basic Reporting

## Commands Used

```powershell
Get-CimInstance
Select-Object
Get-Volume
Write-Host
Get-Date
```

##### Sample output
![System Information](Screenshots/Screenshot%202026-06-21%20222146.jpg)

## Information Collected

* Computer Name
* Operating System
* OS Version
* Processor Information
* Total Physical Memory
* Disk Capacity
* Available Disk Space
* Report Generation Time

## Real-World Use Case

IT Support and System Administrators frequently need to gather device information for troubleshooting, inventory management, documentation, and health checks.

This script automates the collection of common system details and presents them in a structured report.

## Skills Gained

* Querying Windows system information
* Working with PowerShell objects
* Formatting command output
* Creating simple administrative reports

## Reflection

Today I created my first practical PowerShell administration script. Instead of focusing only on syntax, I built a tool that could be used by an IT Support Technician or System Administrator to quickly gather system information from a workstation or server.
