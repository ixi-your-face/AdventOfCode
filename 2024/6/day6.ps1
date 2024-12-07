using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$ErrorActionPreference = "Stop"

$PatrolMap = (Get-Content $InputFile)

$MaxX = $PatrolMap[0].Length
$MaxY = $PatrolMap.Count
$Directions = "^>V<"
$DirectionNames = ("Up","Right","Down","Left")

function Find-Guard($PatrolMap){
    $Regex = "[V<>^]"

    for($i = 0; $i -lt $PatrolMap.Count; $i++){
        $GuardLocation = [Regex]::Match($PatrolMap[$i],"[V<>\^]")

        Switch($GuardLocation.Value){
            "^" {$Direction = "Up"}
            "V" {$Direction = "Down"}
            "<" {$Direction = "Left"}
            ">" {$Direction = "Right"}
        }

        if($GuardLocation.Success){
            $ReturnObj = [PSCustomObject]@{
                X = $GuardLocation.Index
                Y = $i
                Direction = $Direction
                DirectionChar = $GuardLocation.Value
            }

            return $ReturnObj
        }
    }
}

function Update-Line($Char, [String]$Line, $Index){
    $CharArray = $Line.ToCharArray()

    $CharArray[$Index] = $Char

    return ($CharArray -Join "")
}

$GuardLocation = (Find-Guard $PatrolMap)
$BreadCrumb = "X"

clear-host

do{
    try{
        $CardinalSurroundings = [PSCustomObject]@{
            Up = [PSCustomObject]@{
                Char = ($PatrolMap[($GuardLocation.Y - 1)][$GuardLocation.X])
                X = $GuardLocation.X
                Y = ($GuardLocation.Y - 1)
            }
            Down = [PSCustomObject]@{
                Char = ($PatrolMap[($GuardLocation.Y + 1)][$GuardLocation.X])
                X = $GuardLocation.X
                Y = ($GuardLocation.Y + 1)
            }
            Left = [PSCustomObject]@{
                Char = ($PatrolMap[$GuardLocation.Y][($GuardLocation.X - 1)])
                X = ($GuardLocation.X - 1)
                Y = $GuardLocation.Y
            }
            Right = [PSCustomObject]@{
                Char = ($PatrolMap[$GuardLocation.Y][($GuardLocation.X + 1)])
                X = ($GuardLocation.X + 1)
                Y = $GuardLocation.Y
            }
        }
    } catch {
        $OutOfBounds = $true
    }

    $DesiredDirection = $CardinalSurroundings.$($GuardLocation.Direction)
    $DotPosX = $DesiredDirection.X
    $DotPosY = $DesiredDirection.Y

    if($DesiredDirection.Char -eq "#"){
            # Turn Right
            $NextDirectionIndex = (($Directions.IndexOf($GuardLocation.DirectionChar) + 1) % $Directions.Length)
            $NextDirection = $Directions[$NextDirectionIndex]

            $NextDirectionnameIndex = (($DirectionNames.IndexOf($GuardLocation.Direction) + 1) % $DirectionNames.Length)
            $NextDirectionName = $DirectionNames[$NextDirectionnameIndex]

            $PatrolMap[$GuardLocation.Y] = (Update-Line $NextDirection $PatrolMap[$GuardLocation.Y] $GuardLocation.X)

            $GuardLocation.DirectionChar = $NextDirection
            $GuardLocation.Direction = $NextDirectionName
            continue
    }

    if(($DotPosX -ge $MaxX) -or ($DotPosX -lt 0)){
        $OutOfBounds = $true
    }

    # Set new Guard Location
    $PatrolMap[$DotPosY] = (Update-Line $GuardLocation.DirectionChar $PatrolMap[$DotPosY] $DotPosX)

    # Place breadcrumb
    $PatrolMap[$GuardLocation.Y] = (Update-Line $BreadCrumb $PatrolMap[$GuardLocation.Y] $GuardLocation.X)

    $GuardLocation.X = $DotPosX
    $GuardLocation.Y = $DotPosY

    $host.UI.RawUI.CursorPosition = @{ x = 0; y = 0 }
    $PatrolMap -Join "`n"

}While(!($OutOfBounds))

$NumberOfBreadCrumbs = [Regex]::Matches($PatrolMap, "X")

Write-Host "Part 1: $($NumberOfBreadCrumbs.Count)"

#Regex: [V^><](.*)#
