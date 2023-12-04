[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    $InputGame
)

begin {
    Enum Hands {
        rock = 0
        paper = 1
        scissors = 2
    }

    Enum Outcome {
        loss = 0
        draw = 3
        win = 6
    }

    function Find-Hand($Hand) {
        switch -Regex ($Hand) {
            "A|X" {
                $Output = [Hands]::rock
            }
            "B|Y" {
                $Output = [Hands]::paper
            }
            "C|Z" {
                $Output = [Hands]::scissors
            }
        }

        return $Output
    }

    $Strategy = (Get-Content $InputGame)

    $Plays = ("A", "B", "C")

    $TotalScore = 0
}

process {
    foreach($Game in $Strategy){
        $Positions = $Game.Split(" ")

        $Opponent = (Find-Hand $Positions[0])

        $PlayInt = ($Plays.IndexOf($Positions[0]))

        switch($Positions[1]){
            "X" {
                # loss
                $Strat = $Plays[($PlayInt - 1)]
            }

            "Y" {
                $Strat = $Positions[0]
            }

            "Z" {
                # win
                $Strat = $Plays[($PlayInt + 1)]
            }
        }

        $Play = (Find-Hand $Strat)
        

        if($Opponent -eq $Play){
            $Outcome = [Outcome]::draw
        } elseif ((($Play + 1) % 3) -eq $Opponent){
            $Outcome = [Outcome]::loss
        } else {
            $Outcome = [Outcome]::win
        }

        $TotalScore += ($Outcome.value__ + $Play.value__ + 1)
    }
}

end {
    return $TotalScore
}
