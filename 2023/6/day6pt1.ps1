function Import-TestData{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data           = (Get-Content $Path)
    $Lines          = [system.collections.generic.list[Array]]::New()
    $NumberRegex    = "\d+"

    foreach($Line in $Data){
        $Numbers = [int[]]([regex]::Matches($Line, $NumberRegex).Value)

        $Lines.Add($Numbers)
    }

    return $Lines
}

function Measure-MaxWins{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [system.collections.generic.list[Array]]
        $Data
    )

    $NumberOfGames  = ($Data[0].Count)

    $WinningGames   = [system.collections.generic.list[int[]]]::New()
    
    for($Game = 0; $Game -lt $NumberOfGames; $Game++){

        $LengthOfTime   = $Data[0][$Game]
        $DistanceToBeat = $Data[1][$Game]

        $PossibleWins = [System.Collections.Generic.list[int]]::New()

        for($HoldDownLength = 0; $HoldDownLength -lt $LengthOfTime; $HoldDownLength++){

            $DistanceTravelled = ($HoldDownLength * ($LengthOfTime - $HoldDownLength))

            if($DistanceTravelled -gt $DistanceToBeat){
                $PossibleWins.Add($DistanceTravelled)
            }
        }

        $WinningGames.Add($PossibleWins)
    }

    return $WinningGames
}

function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $GameData = (Import-TestData $Path)

    $WinningGames = (Measure-MaxWins $GameData)

    $TotalValue = ($WinningGames[0].Length)

    for($Game = 1; $Game -lt $WinningGames.Count; $Game++){
        $TotalValue = $TotalValue * ($WinningGames[$Game].Length)
    }

    return $TotalValue
}