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

        for($Index = 0; $Index -lt ($Hand.Length - 1); $Index++){
            $Card = [string]($Hand[$Index])

            if($Card -match "[KQJAT]"){
                $Card = [int]([LetterCard]::$Card)
            }

            $Cards.Add([int]$Card)
        }

        $Cards.Sort()
        $Cards.Reverse()

        $LineData = [PSCustomObject]@{
            Hand = $Cards
            Multiplier = $Multiplier
        }

        $OutputList.Add($LineData)
    }

    return $OutputList
}

