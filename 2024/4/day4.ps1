using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$WordSearch = [ArrayList](Get-Content $InputFile)
$ErrorActionPreference = "SilentlyContinue"

$DiagonalCount = 0
$UpdownCount = 0
$LeftRightCount = 0
$XofMAS = 0

$MaxX = $WordSearch[0].Length
$MaxY = $WordSearch.Count

function Confirm-XMAS($Line){
    $WordList = @(
        "XMAS",
        "SAMX"
    )

    $FoundWordCount = 0

    foreach($Word in $WordList){
        $FoundWordCount += ([Regex]::Matches($Line, $Word)).Count
    }
    
    return $FoundWordCount
}

function Find-DiagonalStrings($WordSearch, $LineIndex, $LetterIndex){
    $Diagonal1 = [ArrayList]::New()
    $Diagonal2 = [ArrayList]::New()

    $LineCount = $WordSearch.Count
    $CharCount = $WordSearch[0].Length

    for($i = -2; $i -le 2; $i++){
        if((($LineIndex + $i) -lt 0)){
            continue
        }

        if(($LetterIndex + $i) -ge 0){
            [Void]$Diagonal2.Add($WordSearch[$LineIndex + $i][$LetterIndex + $i])
        }
        
        if((($LetterIndex - $i) -ge 0)){
            [Void]$Diagonal1.Add($WordSearch[$LineIndex + $i][$LetterIndex - $i])
        }
    }

    $Diagonals = @(
        ($Diagonal1 -Join ""),
        ($Diagonal2 -Join "")
    )

    return $Diagonals
}



for($LineIndex = 0; $LineIndex -lt $MaxY; $LineIndex++){
    for($LetterIndex = 0; $LetterIndex -lt $MaxX; $LetterIndex++){

        if($WordSearch[$LineIndex][$LetterIndex] -ne "A"){
            continue
        }
        
        $Diagonals = (Find-DiagonalStrings $WordSearch $LineIndex $LetterIndex)

        foreach($Diagonal in $Diagonals){
            if($Diagonal -Like "*SAMX") {$DiagonalCount++}
            if($Diagonal -Like "XMAS*") {$DiagonalCount++}
        }

        if((($Diagonals[0] -Like "*MAS*") -or ($Diagonals[0] -Like "*SAM*")) -and (($Diagonals[1] -Like "*MAS*") -or ($Diagonals[1] -Like "*SAM*"))){
            $XofMAS++
        }
    }
}

for($x = 0; $x -lt $MaxX; $x++){
    $UpDownRow = [ArrayList]::New()
    
    for($y = 0; $y -lt $MaxY; $y++){
        [Void]$UpDownRow.Add($WordSearch[$y][$x])
    }

    $UpdownCount += (Confirm-XMAS ($UpDownRow -Join ""))
}


# This is the counter.
foreach($Line in $WordSearch){
    $LeftRightCount += (Confirm-XMAS ($Line -Join ""))
}

Write-Host "Part 1: $($LeftRightCount + $UpDownCount + $DiagonalCount)"
Write-Host "Part 2: $XofMAS"