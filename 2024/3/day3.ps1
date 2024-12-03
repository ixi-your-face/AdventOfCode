using namespace System.Collections

[CmdletBinding()]
param (
    $InputFile = ".\input.txt"
)

$InstructionSet = (Get-Content $InputFile -Raw)
$InstructionSet = "START" + $InstructionSet.Replace("don't()", "HERESTOP").Replace("do()", "HERESTART")

function Get-Total($InstructionSet){
    $Total = 0
    $BaseMultiplicationRegex = "mul\((\d+)\,(\d+)\)"

    $AllQiplications = [Regex]::Matches($InstructionSet, $BaseMultiplicationRegex)

    foreach($Operation in $AllQiplications){
        $Total += ([BigInt]$Operation.Groups[1].Value * [BigInt]$Operation.Groups[2].Value)
    }

    return $Total
}

$Part2Base = $InstructionSet.Split("HERE")

foreach($Operation in $Part2Base){
    if($Operation.StartsWith("START")){
        $Part2Total += Get-Total $Operation
    }
}


write-host (Get-Total $InstructionSet)
write-host $Part2Total