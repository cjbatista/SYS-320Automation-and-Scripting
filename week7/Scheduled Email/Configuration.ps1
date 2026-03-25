function readConfiguration {
    $fileContent = Get-Content -Path "configuration.txt"
    $foo = [PSCustomObject]@{
        "Days"          = $fileContent[0]   # fixed: no Split needed
        "ExecutionTime" = $fileContent[1]
    }
    return $foo
}

function changeConfiguration {
    do {
        $newDays = Read-Host "Enter new days of logs to pull"
        if ($newDays -notmatch '^\d+$') { Write-Host "Digits only!" -ForegroundColor Yellow }
    } while ($newDays -notmatch '^\d+$')

    do {
        $newTime = Read-Host "Enter new execution time (e.g. 1:12 PM)"
        if ($newTime -notmatch '^\d{1,2}:\d{2}\s(AM|PM)$') { Write-Host "Use format H:MM AM/PM" -ForegroundColor Yellow }
    } while ($newTime -notmatch '^\d{1,2}:\d{2}\s(AM|PM)$')

    Set-Content -Path "configuration.txt" -Value @($newDays, $newTime)
    Write-Host "Configuration updated" -ForegroundColor Green
}

function configurationMenu {
    $Prompt  = "Please choose your operation:`n"
    $Prompt += "1 - Display config`n"
    $Prompt += "2 - Change config`n"
    $Prompt += "3 - Exit`n"

    do {
        Write-Host $Prompt
        $choice = Read-Host

        if ($choice -notmatch '^[123]$') {
            Write-Host "Unknown Option: $choice — enter 1, 2, or 3" -ForegroundColor Yellow
        }
        elseif ($choice -eq "1") {
            $boy = readConfiguration
            Write-Host ($boy | Format-List | Out-String)
        }
        elseif ($choice -eq "2") {
            changeConfiguration
        }

    } while ($choice -ne "3")

    Write-Host "Exiting..." -ForegroundColor Green
}

configurationMenu
