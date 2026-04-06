
### Summary of how the whole script flows:

1. Reads your parameters
2. Sets up logging folder
3. Defines the ```Write-Log``` helper function
4. Loops through every computer → queries disks → logs results → collects alerts
5. If alerts exist → sends them via email and/or Slack
6. Always logs the outcome
