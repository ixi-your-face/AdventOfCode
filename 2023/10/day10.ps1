function Find-StartPoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Maze
    )

    $LineCount  = ($Maze.Count - 1)
    $LineLength = ($Maze[0].Length - 1)

    for($Line = 0; $Line -lt $LineCount; $Line++){
        for($CharIndex = 0; $CharIndex -lt $LineLength; $CharIndex++){
            $CurrentChar = $Maze[$Line][$CharIndex]

            if($CurrentChar -eq "S"){
                return [PSCustomObject]@{
                    Y = $Line
                    X = $CharIndex
                }
            }
        }
    }
}

function Find-ValidPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $CurrentCoordinate,
        [Parameter(Mandatory)]
        $Maze
    )

    # "|" is a vertical pipe connecting north and south.
    # "-" is a horizontal pipe connecting east and west.
    # "L" is a 90-degree bend connecting north and east.
    # "J" is a 90-degree bend connecting north and west.
    # "7" is a 90-degree bend connecting south and west.
    # "F" is a 90-degree bend connecting south and east.

    $CurrentChar = $Maze[$CurrentCoordinate.Y][$CurrentCoordinate.X]

    $ValidCoordinates = [System.Collections.ArrayList]::New()

    switch($CurrentChar){
        "|" {
            $ValidMoves = @{
                Up = @("|", "7", "F", "S")
                Down = @("|", "L", "J", "S")
                Left = $false
                Right = $false
            }
        }
        "-" {
            $ValidMoves = @{
                Up = $false
                Down = $false
                Left = @("-", "L", "F", "S")
                Right = @("-", "7", "J", "S")
            }
        }
        "L" {
            $ValidMoves = @{
                Up = @("|", "F", "7", "S")
                Down = $false
                Left = $false
                Right = @("-", "7", "J", "S")
            }
        }
        "J" {
            $ValidMoves = @{
                Up = @("|", "F", "7", "S")
                Down = $false
                Left = @("-", "F", "L", "S")
                Right = $false
            }
        }
        "7" {
            $ValidMoves = @{
                Up = $false
                Down = @("|", "L", "J", "S")
                Left = @("-", "L", "F", "S")
                Right = $false
            }
        }
        "F" {
            $ValidMoves = @{
                Up = $false
                Down = @("|", "L", "J", "S")
                Left = $false
                Right = @("-", "7", "J", "S")
            }
        }
        "S" {
            $ValidMoves = @{
                Up = @("|", "7", "F")
                Down = @("|", "L", "J")
                Left = @("-", "L", "F")
                Right = @("-", "7", "J")
            }
        }
    }

    if($ValidMoves.Up){
        $ValidX = $CurrentCoordinate.X
        $ValidY = $CurrentCoordinate.Y - 1

        $Char = $Maze[$ValidY][$ValidX]

        if($ValidMoves.Up -Contains $Char){
            [void]$ValidCoordinates.Add(
                [PSCustomObject]@{
                    Y = $ValidY
                    X = $ValidX
                }
            )
        }
    }

    if($ValidMoves.Down){
        $ValidX = $CurrentCoordinate.X
        $ValidY = $CurrentCoordinate.Y + 1

        $Char = $Maze[$ValidY][$ValidX]

        Write-Host "Down! $Char"

        if($ValidMoves.Down -Contains $Char){
            [void]$ValidCoordinates.Add(
                [PSCustomObject]@{
                    Y = $ValidY
                    X = $ValidX
                }
            )
        }
    }

    if($ValidMoves.Left){
        $ValidX = $CurrentCoordinate.X - 1
        $ValidY = $CurrentCoordinate.Y

        $Char = $Maze[$ValidY][$ValidX]

        if($ValidMoves.Left -Contains $Char){
            [void]$ValidCoordinates.Add(
                [PSCustomObject]@{
                    Y = $ValidY
                    X = $ValidX
                }
            )
        }
    }

    if($ValidMoves.Right){
        $ValidX = $CurrentCoordinate.X + 1
        $ValidY = $CurrentCoordinate.Y

        $Char = $Maze[$ValidY][$ValidX]

        if($ValidMoves.Right -Contains $Char){
            [void]$ValidCoordinates.Add(
                [PSCustomObject]@{
                    Y = $ValidY
                    X = $ValidX
                }
            )
        }
    }

    return $ValidCoordinates
}

function Convert-CoordinateToStringToMakeItFindable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Coordinate
    )

    return "$($Coordinate.Y)|$($Coordinate.X)"
}

function Move-ThroughMaze {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Maze
    )

    $CurrentCoordinate = (Find-StartPoint $Maze)
    $MazeMap = [System.Collections.ArrayList]::New()

    $MapCoordinate = (Convert-CoordinateToStringToMakeItFindable $CurrentCoordinate)
    [void]$MazeMap.Add($MapCoordinate)

    $CurrentChar = ""

    Write-Host "Starting Point $($CurrentCoordinate.Y), $($CurrentCoordinate.X)"

    # LOOP
        # Get Current Coordinate
        # Look to see what's around
        # Determine a point to move to from valid moves
        # Set where I want to go to as current coordinate

    while($CurrentChar -ne "S"){

        Write-Host "Current COORDINATE MAP"
        Write-Host $MazeMap
    
        $NextMoves = (Find-ValidPath -CurrentCoordinate $CurrentCoordinate -Maze $Maze)

        Write-Host "Next Moves:"
        Write-Host $NextMoves
        Write-Host "Currently positioned at $($CurrentCoordinate)"

        for($Moves = 0; $Moves -lt ($NextMoves.Count - 1); $Moves++){

            $MapCoordinate = (Convert-CoordinateToStringToMakeItFindable $NextMoves[$Moves])
            
            if($MazeMap.Contains($MapCoordinate)){
                continue

                Write-Host "Skipping! $MapCoordinate"
            }

            Write-Host "$($NextMoves[$Moves]) Not In Map. Going there!"
            $CurrentCoordinate = $NextMoves[$Moves]

            $CurrentChar = $Maze[$CurrentCoordinate.Y][$CurrentCoordinate.X]

            
            [void]$MazeMap.Add($MapCoordinate)
        }

        Write-Host "----------------------------------------------------------"
    }
}