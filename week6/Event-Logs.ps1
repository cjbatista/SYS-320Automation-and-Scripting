. (Join-Path $PSScriptRoot String-Helper.ps1)

<# ******************************
   Function: getLogInAndOffs
   Input:   1) Number of days to look back
   Output:  1) Table of login/logoff events
****************************** #>
function getLogInAndOffs($timeBack){
    $loginouts = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays("-"+"$timeBack")
    
    $loginoutsTable = @()
    for($i=0; $i -lt $loginouts.Count; $i++){
        $type = ""
        if($loginouts[$i].InstanceID -eq 7001){ $type = "Logon" }
        if($loginouts[$i].InstanceID -eq 7002){ $type = "Logoff" }
        
        $user = (New-Object System.Security.Principal.SecurityIdentifier $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        $loginoutsTable += [pscustomobject]@{"Time"  = $loginouts[$i].TimeGenerated
                                             "Id"    = $loginouts[$i].InstanceId
                                             "Event" = $type
                                             "User"  = $user
        }
    }
    return $loginoutsTable
}

<# ******************************
   Function: getFailedLogins
   Input:   1) Number of days to look back
   Output:  1) Table of failed login events with user info
****************************** #>
function getFailedLogins($timeBack){
    
    $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where-Object { $_.InstanceID -eq "4625" }
    
    $failedloginsTable = @()
    for($i=0; $i -lt $failedlogins.Count; $i++){
        
        $account = ""
        $domain  = ""
        
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
