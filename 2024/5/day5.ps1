using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$PageInstructions = (Get-Content $InputFile)
$PageRules = [ArrayList]::New()
$PageOrders = [ArrayList]::New()
$ValidPages = [ArrayList]::New()
$InvalidPages = [ArrayList]::New()
$Part1Totals = 0
$Part2Totals = 0


foreach($Line in $PageInstructions){
    switch ($Line) {
        {$_.Contains('|')} {
            $SplitLine = $Line.Split('|')

            $Rule = [PSCustomObject]@{
                Before = $SplitLine[0]
                After = $SplitLine[1]
            }

            [Void]$PageRules.Add($Rule)
        }
        {$_.Contains(',')} {[Void]$PageOrders.Add([ArrayList]$Line.Split(','))}
        Default {continue}
    }
}

$OrderedRules = ($PageRules | Sort-Object Before | Group Before -AsHashTable)

function Test-Valid ($OrderedRules, $Page){
    foreach($Number in $Page){
        $NumberRules = $OrderedRules.$Number.After
        $NumberIndex = $Page.IndexOf($Number)

        foreach($Rule in $NumberRules){
            $RuleIndex = $Page.IndexOf($Rule)

            if($RuleIndex -eq -1){ continue }

            if($RuleIndex -lt $NumberIndex){
                return $false
            }
        }
    }

    return $true
}

foreach($Update in $PageOrders){
    $IsValid = (Test-Valid $OrderedRules $Update)

    if($IsValid){
        [Void]$ValidPages.Add($Update)
    } else {
        [Void]$InvalidPages.Add($Update)
    }
}

foreach($InvalidPage in $InvalidPages){
    while(!(Test-Valid $OrderedRules $InvalidPage)){
        for($i = 0; $i -lt $InvalidPage.Count; $i++){
            $Number = $InvalidPage[$i]
            $NumberRules = $OrderedRules.$Number.After
            $NumberIndex = $InvalidPage.IndexOf($Number)
    
            foreach($Rule in $NumberRules){
                $RuleIndex = $InvalidPage.IndexOf($Rule)
    
                if($RuleIndex -eq -1){ continue }
    
                if($RuleIndex -lt $NumberIndex){
                    [Void]$InvalidPage.Remove($Number)
                    [Void]$InvalidPage.Insert($RuleIndex, $Number)
                }
            }
        }
    }
}

foreach($ValidPage in $ValidPages){
    $MiddleNumber = [int]$ValidPage[[Math]::Floor($ValidPage.Count/2)]

    $Part1Totals += $MiddleNumber
}

foreach($InvalidPage in $InvalidPages){
    $MiddleNumber = [int]$InvalidPage[[Math]::Floor($InvalidPage.Count/2)]

    $Part2totals += $MiddleNumber
}

Write-Host "Part 1: $Part1Totals"
Write-Host "Part 2: $Part2Totals"