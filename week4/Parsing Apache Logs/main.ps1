. (Join-Path $PSScriptRoot "parselogs.ps1")

$tr = ApacheLogs1
$tr | Format-Table -AutoSize -Wrap
