using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$ReactorData = (Get-Content $InputFile)
$GoodData = 0
$TolerableData = 0

function Test-ForBadReadings ($Line) {
    $Direction = ($Line[1] - $Line[0])

    for($i = 1; $i -lt $Line.Count; $i++){
        $CurrentLevel = $Line[$i]
        $PreviousLevel = $Line[($i - 1)]

        $LevelDiff = ($CurrentLevel - $PreviousLevel)

        if(!(
                ((1..3) -Contains [Math]::Abs($LevelDiff)) -and
                (($CurrentLevel - $PreviousLevel) * $Direction -gt 0)
            )
        ){
            return $false
        }
    }

    return $true
}

foreach($Line in $ReactorData){
    $Data = [ArrayList]::New($Line.Split(" "))

    $TestResult = (Test-ForBadReadings $Data)

    $GoodData += $TestResult

    if(!($TestResult)){
        for($i=0; $i -lt $Data.Count; $i++){
            $NewIndicies = [System.Collections.ArrayList]@(0..$Data.Count)
            $NewIndicies.RemoveAt($i)

            $TestResult = Test-ForBadReadings $Data[$NewIndicies]

            if($TestResult){
                break
            }
        }
    }

    $TolerableData += $TestResult
}

Write-Host "Good: $GoodData"
Write-Host "Dampened: $TolerableData"