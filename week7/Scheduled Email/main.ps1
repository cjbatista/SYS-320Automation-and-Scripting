. (Join-Path $PSScriptRoot Configuration.ps1)
. (Join-Path $PSScriptRoot Email.ps1)
. (Join-Path $PSScriptRoot Scheduler.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

$configuration = readConfiguration
$Failed = atRiskUsers $configuration.Days
SendAlertEmail "Suspicious Activity" $Failed
ChooseTimeToRun $configuration.ExecutionTime
