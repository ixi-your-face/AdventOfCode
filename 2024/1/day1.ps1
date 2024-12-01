using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$LeftSide = [ArrayList]::New()
$RightSide = [ArrayList]::New()
$Regex = "^(\d+)\s+(\d+)$"
$Part1Total = 0
$Part2Total = 0
$InputData = (Get-Content $InputFile)

foreach($Line in $InputData){
    $Numbers = [Regex]::Match($line, $Regex)

    [Void]$LeftSide.Add([int]$Numbers.Groups[1].Value)
    [Void]$RightSide.Add([int]$Numbers.Groups[2].Value)
}

$LeftSide.Sort()
$RightSide.Sort()
$GroupedRight = ($RightSide | Group-Object -AsHashTable)

for($i = 0; $i -lt $LeftSide.Count; $i++){
    $NumberOnRight = ($GroupedRight[$LeftSide[$i]].Count)

    $Part1Total += [Math]::Abs(($LeftSide[$i] - $RightSide[$i]))
    $Part2Value = ($LeftSide[$i] * $NumberOnRight)
    
    if($Part2Value -eq 0){
        continue
    }
    
    $Part2Total += $Part2Value
}

Write-Host "Part 1: $Part1Total"
Write-Host "Part 2: $Part2Total"