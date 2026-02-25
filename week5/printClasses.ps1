. (Join-Path $PSScriptRoot gatherclasses.ps1)

$FullTable = daysTranslator(gatherclasses)

#$FullTable | Where-Object { ($_.Location -eq "FREE 105") -and ($_.days -contains "Wednesday") } |
#    Sort-Object "Time Start" | `
 #   Select-Object "Time Start", "Time End", "Class Code"

#$FullTable | 
#    Where-Object { $_."Class Code" -match '^(SYS|NET|SEC|FOR|CSI|DAT)' } |
#    Select-Object -Expandproperty Instructor | 
#    Sort-Object -Unique

$FullTable |
    Group-Object Instructor |
    Sort-Object Count -Descending |
    Select-Object Count, Name