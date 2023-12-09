#region Helper Functions

function Import-TestData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path,
        [switch]
        $Reverse
    )

    $Lines = [System.Collections.Generic.List[int64[]]]::New()

    $Data         = (Get-Content $Path)
    $NumbersRegex = "-\d+|\d+"

    foreach($Line in $Data){
        $Numbers = [System.Collections.Generic.List[int64]]([regex]::Matches($Line, $NumbersRegex)).value

        if($Reverse){
            $Numbers.Reverse()
        }

        $Lines.Add($Numbers)
    }

    return $Lines
}

function Find-Pascal {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $NumberArray
    )

    $ArrayLength = ($NumberArray.Length - 1)

    $NumberDiffs = [System.Collections.Generic.List[int64]]::New()
    $NumberTally = 0

    for($Number = $ArrayLength; $Number -gt 0 ; $Number--){
        [int64]$CurrentNumber   = $NumberArray[$Number]
        [int64]$NumberBefore    = ($NumberArray[$Number - 1])
        [int64]$NumberBelow     = ($CurrentNumber - $NumberBefore)

        $NumberTally            += $NumberBelow

        $NumberDiffs.Add($NumberBelow)
    }

    $NumberDiffs.Reverse()

    return $NumberDiffs
}

function Find-NextNumber {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $NumberArray
    )

    $ArrayCount     = ($NumberArray.Count) - 2
    $LastRunNumber  = 0

    for($Array = $ArrayCount; $Array -ge 0 ; $Array--){
        $LineLength = (($NumberArray[$Array]).Length - 1)
        $LastNumber = ($NumberArray[$Array][$LineLength])

        $LastRunNumber += $LastNumber
    }

    return $LastRunNumber
}

#endregion

function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Import-TestData $Path)
    $TotalNumber = 0

    foreach($Line in $Data){
        $LineArray  = [System.Collections.Generic.List[int64[]]]::New()
        $LineArray.Add($Line)

        $NextLine = $Line

        $StopLooping = $false

        while(!($StopLooping)){
            $NextLine = (Find-Pascal $NextLine)

            $LineArray.Add($NextLine)

            $SumOfArray = (($NextLine | Measure-Object -sum).sum)

            if($SumOfArray -eq 0){
                $StopLooping = $true
            }
        }

        $TotalNumber += (Find-NextNumber $LineArray)
    }

    return $TotalNumber
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Import-TestData $Path -Reverse)
    $TotalNumber = 0

    foreach($Line in $Data){
        $StopLooping = $false

        $LineArray = [System.Collections.Generic.List[int64[]]]::New()
        $LineArray.Add($Line)

        $NextLine = $Line

        while(!($StopLooping)){
            $NextLine = (Find-Pascal $NextLine)

            $LineArray.Add($NextLine)

            $SumOfArray = (($NextLine | Measure-Object -sum).sum)

            if($SumOfArray -eq 0){
                $StopLooping = $true
            }
        }

        $TotalNumber += (Find-NextNumber $LineArray)
    }

    return $TotalNumber
}