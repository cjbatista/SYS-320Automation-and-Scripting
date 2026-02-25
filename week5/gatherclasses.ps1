function gatherClasses() {
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.32/Courses2026SP.html
    $trs = $page.ParsedHtml.getElementsByTagName('tr')
    $FullTable = @()
    for ($i = 1; $i -lt $trs.length; $i++) {
        $tds = $trs[$i].getElementsByTagName('td')
        if ($tds.length -lt 10) {continue}

        $times = $tds[5].innerText.Split('-')

        $FullTable += [PSCustomObject]@{"Class Code"  = $tds[0].innerText;
                                        "Title"       = $tds[1].innerText;
                                        "Days"        = $tds[4].innerText;
                                        "Time Start"  = $times[0];
                                        "Time End"    = $times[1];
                                        "Instructor"  = $tds[6].innerText;
                                        "Location"    = $tds[9].innerText;
        }
    }       
    return $FullTable
}           