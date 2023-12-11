enum RPSLS {
    Rock
    Paper
    Scissors
    Lizard
    Spock
}

function Get-Winner{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [RPSLS]
        $Player1,
        [Parameter(Mandatory)]
        [RPSLS]
        $Player2
    )

    if($Player1 -eq $Player2){
        return "draw"
    }

    switch($Player1){
        Rock {
            $WinningPlays = @(
                [RPSLS]::Lizard,
                [RPSLS]::Scissors
            )

            if($WinningPlays.Contains($Player2)){
                return "Player 1 wins!"
            }

            return "Player 2 wins!"
        }
        Paper {
            $WinningPlays = @(
                [RPSLS]::Rock,
                [RPSLS]::Spock
            )

            if($WinningPlays.Contains($Player2)){
                return "Player 1 wins!"
            }

            return "Player 2 wins!"
        }
        Scissors {
            $WinningPlays = @(
                [RPSLS]::Paper,
                [RPSLS]::Lizard
            )

            if($WinningPlays.Contains($Player2)){
                return "Player 1 wins!"
            }

            return "Player 2 wins!"
        }
        Lizard {
            $WinningPlays = @(
                [RPSLS]::Spock,
                [RPSLS]::Paper
            )

            if($WinningPlays.Contains($Player2)){
                return "Player 1 wins!"
            }

            return "Player 2 wins!"
        }
        Spock {
            $WinningPlays = @(
                [RPSLS]::Scissors,
                [RPSLS]::Rock
            )

            if($WinningPlays.Contains($Player2)){
                return "Player 1 wins!"
            }

            return "Player 2 wins!"
        }
    }
}



# Rock crushes Lizard
# Rock crushes Scissors
# 
# Paper covers Rock
# Paper disproves Spock
# 
# Scissors cuts Paper
# Scissors decapitates Lizard
# 
# Lizard poisons Spock
# Lizard eats Paper
# 
# Spock smashes Scissors
# Spock vaporizes Rock