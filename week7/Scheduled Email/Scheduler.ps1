function ChooseTimeToRun($Time) {
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.TaskName -ilike "myTask" }

    if ($null -ne $scheduledTasks) {
        Write-Host "Task already exists — replacing it." -ForegroundColor Yellow
        DisableAutoRun
    }

    Write-Host "Creating new task." -ForegroundColor Cyan

    $action    = New-ScheduledTaskAction -Execute "powershell.exe" `
                     -Argument "-File `"$PSScriptRoot\main.ps1`""
    $trigger   = New-ScheduledTaskTrigger -Daily -At $Time
    $principal = New-ScheduledTaskPrincipal -UserId 'champuser' -RunLevel Highest
    $settings  = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
    $task      = New-ScheduledTask -Action $action -Trigger $trigger `
                     -Principal $principal -Settings $settings

    Register-ScheduledTask -TaskName "myTask" -InputObject $task
    Get-ScheduledTask | Where-Object { $_.TaskName -ilike "myTask" }
}

function DisableAutoRun() {
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.TaskName -ilike "myTask" }

    if ($null -ne $scheduledTasks) {
        Write-Host "Disabling task..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName "myTask" -Confirm:$false
    }
    else {
        Write-Host "Task does not exist." -ForegroundColor Red
    }
}
