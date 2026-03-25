function SendAlertEmail($Body) {
    $From     = "yourname@gmail.com"                        # Gmail account
    $To       = "charles.batista@mymail.champlain.edu"      # Champlain email
    $Subject  = "SYS 320 Alert Report - $(Get-Date -Format 'yyyy-MM-dd')"
    $Password = Get-Content ./app.txt | ConvertTo-SecureString  # no -AsPlainText
    $Cred     = New-Object System.Management.Automation.PSCredential -ArgumentList $From, $Password

    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body `
                     -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential $Cred
}

SendAlertEmail "Hi! This is a test email for the Email Report script"
