function ApacheLogs1 {

   $logPath = "C:\xampp\apache\logs\access.log"

   if (Test-Path $logPath){

       $logs = Get-Content $logPath -Tail 10
       return $logs

   }
   else{

       Write-Host "Log file not found"

   }
}
