. (Join-Path $PSScriptRoot String-Helper.ps1)

function getLogInAndOffs($timeBack) {
    $loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$timeBack)
    $loginoutsTable = @()
    $limit = [Math]::Min(10, $loginouts.Count)

    for ($i = 0; $i -lt $limit; $i++) {
        if    ($loginouts[$i].InstanceID -eq 7001) { $type = "Logon"  }
        elseif($loginouts[$i].InstanceID -eq 7002) { $type = "Logoff" }
        else                                        { $type = "Unknown ($($loginouts[$i].InstanceID))" }

        try {
            $user = (New-Object System.Security.Principal.SecurityIdentifier `
                     $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        } catch {
            $user = $loginouts[$i].ReplacementStrings[1]
        }

        $loginoutsTable += [pscustomobject]@{
            "Time"  = $loginouts[$i].TimeGenerated
            "Id"    = $loginouts[$i].InstanceId
            "Event" = $type
            "User"  = $user
        }
    }
    return $loginoutsTable
}

function getFailedLogins($timeBack) {
    $failedlogins = Get-EventLog security -After (Get-Date).AddDays(-$timeBack) |
                    Where-Object { $_.InstanceID -eq "4625" }
    $failedloginsTable = @()
    $limit = [Math]::Min(10, $failedlogins.Count)

    for ($i = 0; $i -lt $limit; $i++) {
        $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
        $usr      = $usrlines[1].Split(":")[1].Trim()
        $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
        $dmn      = $dmnlines[1].Split(":")[1].Trim()
        $user     = $dmn + "\" + $usr

        $failedloginsTable += [pscustomobject]@{
            "Time"  = $failedlogins[$i].TimeGenerated
            "Id"    = $failedlogins[$i].InstanceId
            "Event" = "Failed"
            "User"  = $user
        }
    }
    return $failedloginsTable
}

function atRiskUsers($days) {
    return (getFailedLogins $days | Group-Object -Property User |
            Where-Object { $_.Count -gt 9 } | Select-Object Count, Name | Out-String)
}
