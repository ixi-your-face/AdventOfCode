using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

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

function Resolve-RuleViolations($OrderedRules, $InvalidPage){
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

function Get-MiddleTotal($Pages){
    $Output = 0

    foreach($Page in $Pages){
        $MiddleNumber = [int]$Page[[Math]::Floor($Page.Count/2)]
    
        $Output += $MiddleNumber
    }

    return $Output
}

$PageInstructions = (Get-Content $InputFile)
$PageRules = [ArrayList]::New()
$PageOrders = [ArrayList]::New()
$ValidPages = [ArrayList]::New()
$InvalidPages = [ArrayList]::New()

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

$OrderedRules = ($PageRules | Sort-Object Before | Group-Object Before -AsHashTable)

foreach($Update in $PageOrders){
    if(Test-Valid $OrderedRules $Update){
        [Void]$ValidPages.Add($Update)
    } else {
        [Void]$InvalidPages.Add($Update)
    }
}

foreach($InvalidPage in $InvalidPages){
    while(!(Test-Valid $OrderedRules $InvalidPage)){
        Resolve-RuleViolations $OrderedRules $InvalidPage
    }
}

Write-Host "Part 1: $(Get-MiddleTotal $ValidPages)"
Write-Host "Part 2: $(Get-MiddleTotal $InvalidPages)"