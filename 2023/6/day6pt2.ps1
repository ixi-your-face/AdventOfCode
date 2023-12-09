function Import-TestData{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data           = (Get-Content $Path)
    $Lines          = [system.collections.generic.list[bigint]]::New()
    $NumberRegex    = "\d+"

    foreach($Line in $Data){
        $Numbers = [bigint]([regex]::Matches($Line, $NumberRegex).Value -join "")

        $Lines.Add($Numbers)
    }

    return $Lines
}

function Measure-MaxWins{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [system.collections.generic.list[BigInt]]
        $Data
    )

    $NumberOfGames  = ($Data[0].Count)

    $WinningGames   = 0
    
    for($Game = 0; $Game -lt $NumberOfGames; $Game++){

        $LengthOfTime   = $Data[0][$Game]
        $DistanceToBeat = $Data[1][$Game]

        for($HoldDownLength = 0; $HoldDownLength -lt $LengthOfTime; $HoldDownLength++){

            $DistanceTravelled = ($HoldDownLength * ($LengthOfTime - $HoldDownLength))

            if($DistanceTravelled -gt $DistanceToBeat){
                $WinningGames++
            }
        }
    }

    return $WinningGames
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $GameData = (Import-TestData $Path)

    $WinningGames = (Measure-MaxWins $GameData).Count

    return $WinningGames
}