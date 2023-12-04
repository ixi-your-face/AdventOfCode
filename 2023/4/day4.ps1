function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $TestData = (Get-Content $Data)

    $TotalPoints = 0
    $WinningCards = [System.Collections.Generic.List[string]]::New()

    
    foreach($Line in $TestData){
        $CardNumber = $Line.Split(":")[0]
        $ScratchCards = $Line.Split(":")[1].Split("|")

        $AllNumbers = "\d+"

        $Points = 0

        $WinningNumbers = [regex]::Matches($ScratchCards[0], $AllNumbers)
        $NumbersWeHave = [regex]::Matches($ScratchCards[1], $AllNumbers)
        $CardIndex = [regex]::Matches($CardNumber, $AllNumbers)

        $CompareSplat = @{
            ReferenceObject = $NumbersWeHave.Value
            DifferenceObject = $WinningNumbers.Value
            ExcludeDifferent = $true
            IncludeEqual = $true
        }

        $SameNumbers = (Compare-Object @CompareSplat).InputObject

        if(!$SameNumbers){
            Continue
        } else {
            $WinningCards.Add($CardIndex)
        }

        $Points = 1

        for($Iteration = 0; ($Iteration -lt ($SameNumbers.Count - 1)); $Iteration++){
            $Points = $Points * 2
        }

        $TotalPoints += $Points
    }

    $ReturnData = @{
        TotalPoints = $TotalPoints
        WinningCards = $WinningCards
    }

    return $ReturnData
}


function Find-WinningCard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $TestData,
        [Parameter(Mandatory)]
        $Card
    )

    if(($Card - 1) -gt $TestData.Count){
        return
    }

    $Line = $TestData[[int]$Card - 1]

    if(!$line){
        return
    }

    $CardNumber = $Line.Split(":")[0]
    $ScratchCards = $Line.Split(":")[1].Split("|")

    $AllNumbers = "\d+"

    $WinningNumbers = [regex]::Matches($ScratchCards[0], $AllNumbers)
    $NumbersWeHave = [regex]::Matches($ScratchCards[1], $AllNumbers)
    $CardIndex = [regex]::Matches($CardNumber, $AllNumbers)

    $CompareSplat = @{
        ReferenceObject = $NumbersWeHave.Value
        DifferenceObject = $WinningNumbers.Value
        ExcludeDifferent = $true
        IncludeEqual = $true
    }

    $SameNumbers = (Compare-Object @CompareSplat).InputObject

    if($SameNumbers){
        $CardData = [PSCustomObject]@{
            CardNumber = $CardIndex.Value
            Matches = (([int]$Card + 1)..($SameNumbers.Count + $Card))
            RepeatCount = 1
        }
    } else {
        $CardData = [PSCustomObject]@{
            CardNumber = $CardIndex.Value
            Matches = @()
            RepeatCount = 1
        }
    }

    return $CardData
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data
    )

    $TestData = (Get-Content $Data)
    $Outputs = [System.Collections.Generic.List[PSCustomObject]]::New()

    # Get list of all matches
    for($Card = 0; $Card -le $TestData.Count; $Card++){
        $Outputs.Add((Find-WinningCard $TestData ($Card + 1)))
    }
    
    # Iterate over each card
    for($MatchedData = 0; $MatchedData -le $Outputs.Count - 1; $MatchedData++){
        # Extract Card Details
        $WinningCard = $Outputs[$MatchedData]

        # Repeat count will be 1 if there are matches.
        if($WinninCard.RepeatCount -eq 0){
            continue
        }

        # iterate over each winning card
        foreach($RecursiveCard in $WinningCard.Matches){

            # Repeat for each repeat count, add one to each matching number
            for($Repeat = 1; $Repeat -le $WinningCard.RepeatCount; $Repeat++){
                $Outputs[($RecursiveCard - 1)].RepeatCount++
            }
        }
    }

    return $Outputs
}