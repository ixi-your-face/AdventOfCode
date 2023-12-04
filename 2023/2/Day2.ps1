function Confirm-GameValidity {
    [CmdletBinding()]
    param (
        $Matches
    )

    $MaxValues = @{
        Red     = 12
        Green   = 13
        Blue    = 14
    }

    $GamePossible = $true

    foreach($Match in $Matches){
        $Colour = $Match.Groups[2].Value
        $Number = $Match.Groups[1].Value

        if($MaxValues[$Colour] -lt $Number){
            $GamePossible = $false
        }
    }

    return $GamePossible
}

function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $TestData   = (Get-Content $Data)

    $GameIDSum      = 0
    $GamesPossible  = [System.Collections.Generic.List[bool]]::New()

    foreach($Line in $TestData){
        $Game   = ($Line.split(":"))
        $GameID = $Game[0].Split(" ")[1]
        $Regex  = "(\d{2}) (red|green|blue)"

        $Matches        = [regex]::Matches($Game[1],$Regex)
        $GamePossible   = (Confirm-GameValidity $Matches)
        
        if($GamePossible){
            $GameIDSum += $GameID
        }

        $GamesPossible.Add($GamePossible)
    }

    return $GameIDSum
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $TestData   = (Get-Content $Data)
    $GamePower  = 0

    foreach($Line in $TestData){
        $Game   = ($Line.split(":"))

        $Red    = [System.Collections.Generic.List[int]]::New()
        $Green  = [System.Collections.Generic.List[int]]::New()
        $Blue   = [System.Collections.Generic.List[int]]::New()

        $Regex  = "(\d+) (red|green|blue)"

        $Matches = [regex]::Matches($Game[1],$Regex)

        foreach($Match in $Matches){
            switch($Match.Groups[2].Value){
                red {
                    $Red.Add($Match.Groups[1].Value)
                }
                blue {
                    $Blue.Add($Match.Groups[1].Value)
                }
                green {
                    $Green.Add($Match.Groups[1].Value)
                }
            }
        }

        $GamePower += (
            ($Red | Sort-Object -Descending)[0] *
            ($Green | Sort-Object -Descending)[0] *
            ($Blue | Sort-Object -Descending)[0]
        )
    }

    return $GamePower
}