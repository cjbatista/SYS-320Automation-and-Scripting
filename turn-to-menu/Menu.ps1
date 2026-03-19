. (Join-Path $PSScriptRoot "UserManagement.ps1")
. (Join-Path $PSScriptRoot "ApacheLogs.ps1")
. (Join-Path $PSScriptRoot "Process.ps1")
. (Join-Path $PSScriptRoot "Event-Logs.ps1")

$operation = $true

while($operation){

   Write-Host ""
   Write-Host "1: Display last 10 Apache Logs"
   Write-Host "2: Display last 10 Failed Logins"
   Write-Host "3: Display at Risk Users"
   Write-Host "4: Open Chrome to champlain.edu"
   Write-Host "5: Exit"

   $choice = Read-Host "Enter choice (1-5)"

   if($choice -eq "1"){

       $logs = ApacheLogs1
       $logs | Format-Table

   }

   elseif($choice -eq "2"){

       $failed = getFailedLogins 1
       $failed | Select-Object -Last 10 | Format-Table

   }

   elseif($choice -eq "3"){

       $risk = getAtRiskUsers
       $risk | Format-Table

   }

   elseif($choice -eq "4"){

       openChrome

   }

   elseif($choice -eq "5"){

       Write-Host "Goodbye"
       $operation = $false

   }

   else{

       Write-Host "Invalid input. Please enter a number from 1 to 5."

   }
}

