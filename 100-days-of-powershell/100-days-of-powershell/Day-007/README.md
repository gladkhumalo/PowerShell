# Day 007 - Process Manager

## Objective

Develop a PowerShell script that displays the top memory-consuming processes and provides the option to safely terminate a selected process.

## Features

* Lists the top 10 processes by memory usage
* Displays process name, ID, and memory consumption
* Prompts the user to stop a process
* Confirms before terminating the process
* Handles invalid process names gracefully

## Concepts Learned

* Get-Process
* Sort-Object
* Select-Object
* Stop-Process
* Read-Host
* Try/Catch error handling

## Real-World Use Case

IT Support Technicians and System Administrators frequently inspect running processes to troubleshoot performance issues or terminate unresponsive applications. This script demonstrates how PowerShell can simplify that workflow while including a confirmation step to reduce the risk of accidentally stopping the wrong process.

## Skills Gained

* Process monitoring
* Interactive scripting
* Basic error handling
* Safe process management

## Reflection

Today I created a PowerShell tool that helps monitor running processes and safely terminate applications when needed. This project introduced interactive user input and basic exception handling, both of which are important skills for building practical administrative tools.
