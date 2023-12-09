function Import-TestData{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    enum LetterCard {
        K = 14
        Q = 13
        J = 12
        A = 11
        T = 10
    }

    $TestData = (Get-Content $Path)

    $OutputList = [System.Collections.Generic.List[PSCustomObject]]::New()

    foreach($Line in $TestData){
        $CardData = $Line.Split(" ")

        $Hand = $CardData[0]
        $Multiplier = $CardData[1]

        $Cards = [System.Collections.Generic.List[int]]::New()

        for($Index = 0; $Index -lt $Hand.Length; $Index++){
            $Card = ([string]($Hand[$Index]))

            if($Card -match "[KQJAT]"){
                $Card = ([LetterCard]::$Card).value__
            }

            $Card = [int]$Card

            while($Cards.Contains($Card)){
                $Card *= 10
            }

            $Cards.Add([int]$Card)
        }

        $Cards.Sort()
        $Cards.Reverse()

        $LineData = [PSCustomObject]@{
            Hand = $Cards
            Multiplier = $Multiplier
            HandTotal = ($Cards | Measure-Object -sum).Sum
        }

        $OutputList.Add($LineData)
    }

    return $OutputList
}

function Invoke-AoCPart1Attempt2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Cards = ((Import-TestData $Path) | Sort-Object HandTotal)
    $TotalValue = 0

    for($Card = 0; $Card -lt $Cards.Count; $Card++){

        $Multiplier = [int](($Cards[$Card]).Multiplier)

        $TotalValue += ($Multiplier * $Card)
    }

    return $TotalValue

}

function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Cards = (Import-TestData $Path)

    $FiveOfaKind    = [System.Collections.Generic.List[PSCustomObject]]::New()
    $FourOfaKind    = [System.Collections.Generic.List[PSCustomObject]]::New()
    $FullHouse      = [System.Collections.Generic.List[PSCustomObject]]::New()
    $ThreeOfaKind   = [System.Collections.Generic.List[PSCustomObject]]::New()
    $TwoPair        = [System.Collections.Generic.List[PSCustomObject]]::New()
    $OnePair        = [System.Collections.Generic.List[PSCustomObject]]::New()
    $HighCard       = [System.Collections.Generic.List[PSCustomObject]]::New()

    foreach($Card in $Cards){
        $MultipleCards = ($Card.Hand | Group-Object | Sort-Object Count -Descending)

        ($Output.FourOfaKind[0].Hand | Group-Object) | %{if($_.Count -gt 1){($_.Group | %{$_ * 10})}}

        $HighestValue = $MultipleCards[0].Count

        switch($HighestValue){
            5 {
                $FiveOfaKind.Add($Card)
            }
            4 {
                $FourOfaKind.Add($Card)
            }
            3 {
                if($MultipleCards[1].Count -eq 2){
                    $FullHouse.Add($Card)
                    continue
                }
                $ThreeOfaKind.Add($Card)
            }
            2 {
                if($MultipleCards[1].Count -eq 2){
                    $TwoPair.Add($Card)
                    continue
                }

                $OnePair.Add($Card)
            }
            1 {
                $HighCard.Add($Card)
            }
        }
    }

    $Output = @(
        $FiveOfaKind,
        $FourOfaKind,
        $FullHouse,
        $ThreeOfaKind,
        $TwoPair,
        $OnePair,
        $HighCard
    )

    return $Output
}