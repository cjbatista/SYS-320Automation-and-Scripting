 $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
 return $enabledUsers

}

function getNotEnabledUsers(){

 $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" } | Select-Object Name, SID
 return $notEnabledUsers

}

function createAUser($name, $password){

  $params = @{
    Name = $name
    Password = $password
  }

  $newUser = New-LocalUser @params

  Set-LocalUser $newUser -PasswordNeverExpires $false
  Disable-LocalUser $newUser

}

function removeAUser($name){
 
  $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -ilike $name }
  Remove-LocalUser $userToBeDeleted
 
}

function disableAUser($name){
 
  $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -ilike $name }
  Disable-LocalUser $userToBeDeleted
 
}

function enableAUser($name){
 
  $userToBeEnabled = Get-LocalUser | Where-Object { $_.Name -ilike $name }
  Enable-LocalUser $userToBeEnabled
 
}

# Simple at-risk users (disabled accounts)
function getAtRiskUsers(){

  $users = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" }

  $list = @()

  foreach($u in $users){

     $list += [pscustomobject]@{
        Name = $u.Name
        SID  = $u.SID
        Status = "Disabled"
     }

  }

  return $list
}
