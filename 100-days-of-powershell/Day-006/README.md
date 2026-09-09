# Day 006 - Event Log Analyzer — Critical Errors (24h)

## Objective

Retrieve critical Windows System Event Log entries from the last 24 hours using PowerShell.

## Skills Gained

- Get-WinEvent
- FilterHashtable
- Working with dates
- Exporting reports
- Event log analysis

## Technologies

- PowerShell 7
- Windows Event Logs

## Builds on Day 004

[Day 004](../Day-004) also analyzes the Windows System Event Log, but the two scripts take different approaches and answer different questions:

- Day 004 pulls a fixed count of recent events and filters them in the pipeline with `Where-Object`.
- Day 006 filters at the source with `Get-WinEvent -FilterHashtable`, which asks the event log provider to return only matching events instead of filtering after the fact.

| | Day 004 | Day 006 |
| --- | --- | --- |
| Retrieval method | `Get-WinEvent -LogName System -MaxEvents 50` | `Get-WinEvent -FilterHashtable @{ LogName; Level; StartTime }` |
| Filtering | Pipeline (`Where-Object`) after retrieval | Server-side (`FilterHashtable`) at query time |
| Scope | Last 50 events | All events in the last 24 hours |
| Severity | Warnings and Errors | Critical errors only (`Level = 2`) |
| Output | `event-log-report.csv` | `SystemErrors.csv` |

`FilterHashtable` is more efficient for large logs because it narrows the result set before it ever reaches the pipeline, while `Where-Object` is simpler to read but has to inspect every retrieved event.

## Example Output

TimeCreated          Id  ProviderName      Message
-----------          --  ------------      -------
2026-07-23 10:14     41  Kernel-Power      The system has rebooted...
