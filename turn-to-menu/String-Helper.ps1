function getMatchingLines($contents, $lookline){

   $allines = @()
   $splitted = $contents.Split([Environment]::NewLine)

   for($i = 0; $i -lt $splitted.Count; $i++){

       if($splitted[$i].Length -gt 0){

           if($splitted[$i] -ilike $lookline){
               $allines += $splitted[$i]
           }

       }
   }

   return $allines
}
