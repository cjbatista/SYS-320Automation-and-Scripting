. (Join-Path $PSScriptRoot "String-Helper.ps1")

function getLogInAndOffs($timeBack) {

   $events = Get-EventLog system -Source Microsoft-Windows-Winlogon `
             -After (Get-Date).AddDays(-$timeBack)

   $results = @()

   foreach ($event in $events) {

       if ($event.InstanceID -eq 7001) { $type = "Logon" }
       elseif ($event.InstanceID -eq 7002) { $type = "Logoff" }
       else { continue }

       $user = (New-Object System.Security.Principal.SecurityIdentifier `
               $event.ReplacementStrings[1]).Translate(
               [System.Security.Principal.NTAccount])

       $results += [pscustomobject]@{
           Time  = $event.TimeGenerated
           Id    = $event.InstanceID
           Event = $type
           User  = $user
       }
   }

   return $results
}

function getFailedLogins($timeBack) {

   $events = Get-EventLog security `
             -After (Get-Date).AddDays(-$timeBack) |
             Where-Object { $_.InstanceID -eq 4625 }

   $results = @()

   foreach ($event in $events) {

       $userLine = getMatchingLines $event.Message "*Account Name*"
       $domainLine = getMatchingLines $event.Message "*Account Domain*"

       $user = $userLine[1].Split(":")[1].Trim()
       $domain = $domainLine[1].Split(":")[1].Trim()

       $results += [pscustomobject]@{
           Time  = $event.TimeGenerated
           Id    = $event.InstanceID
           Event = "Failed"
           User  = "$domain\$user"
       }
   }

   return $results
}
