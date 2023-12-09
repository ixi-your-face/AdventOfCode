function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $ValueList  = [System.Collections.Generic.List[int]]::New()
    $Total      = 0
    $TestData   = (Get-Content $Data)

    foreach($Line in $TestData){
        $Matches    = [regex]::Matches($Line, "(\d)")
        $FirstValue = $Matches[0].Value
        $LastValue  = $Matches[($Matches.Count - 1)].Value

        [string]$LineValue = $FirstValue+$LastValue

        $ValueList.Add([int]$LineValue)
    }

    foreach($Number in $ValueList){
        $Total += $Number
    }

    return $total
}

function Convert-StringToInt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $String
    )

    switch($String){
        one     {return 1}
        two     {return 2}
        three   {return 3}
        four    {return 4}
        five    {return 5}
        six     {return 6}
        seven   {return 7}
        eight   {return 8}
        nine    {return 9}
    }
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $ValueList  = [System.Collections.Generic.List[int]]::New()
    $Total      = 0
    $TestData   = (Get-Content $Data)

    $Regex = "(?<=(\d|one|two|three|four|five|six|seven|eight|nine))"

    foreach($Line in $TestData){
        $Matches = [regex]::Matches($Line, $Regex)

        $MatchList = [System.Collections.Generic.List[string]]::New()

        foreach($Match in $Matches){
            $Value = [string]($Match.groups[1].value)

            if([regex]::IsMatch($Value, "\D")){
                $Value = (Convert-StringToInt $Value)
            }

            $MatchList.Add($Value)
        }

        $FirstValue = $MatchList[0]
        $LastValue  = $MatchList[($Matches.Count - 1)]
        $LineValue  = [string]$FirstValue + [string]$LastValue

        $ValueList.Add([int]$LineValue)
    }

    foreach($Number in $ValueList){
        $Total += $Number
    }

    return $total
}