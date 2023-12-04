function OldInvoke-AoCPart1 {
   [CmdletBinding()]
   param (
       [Parameter(Mandatory)]
       $Data
   )

   $TestData = (Get-Content $Data)

   $AllSymbols = "[^a-z0-9\.\n\r]"
   $AllNumbers = "\d+"

   $LineDataList = [System.Collections.Generic.List[PSCustomObject]]::New()

   $LineNumber = 0
   $TotalValue = 0

   foreach($Line in $TestData){
       $AdjacentSpaces = [System.Collections.Generic.List[int]]::New()
       $NumberSpaces = [System.Collections.Generic.List[PSCustomObject]]::New()

       $Symbols = [regex]::Matches($Line, $AllSymbols)
       $Numbers = [regex]::Matches($Line, $AllNumbers)

       foreach($Index in $Symbols.Index){
           [Void]$AdjacentSpaces.Add($Index - 1)
           [Void]$AdjacentSpaces.Add($Index)
           [Void]$AdjacentSpaces.Add($Index + 1)
       }

       foreach($Number in $Numbers){
           $StartIndex = $Number.Index
           $EndIndex = ($Number.Index + $Number.Length) - 1

           $NumberIndicies = $StartIndex..$EndIndex

           $NumberData = [PSCustomObject]@{
               Number = $Number.Value
               Indicies = $NumberIndicies
           }
               
           $NumberSpaces.Add($NumberData)
       }

       $LineData = [PSCustomObject]@{
           LineNumber = $LineNumber
           Symbols = $Symbols
           Numbers = $Numbers
           AdjacentSpaces = $AdjacentSpaces
           NumberSpaces = $NumberSpaces
       }

       [Void]$LineDataList.Add($LineData)

       $LineNumber++
   }

   foreach($Entry in $LineDataList){
       $LineAbove = $Entry.LineNumber - 1
       $LineBelow = $Entry.LineNumber + 1

       $AdjacentLines = @($LineAbove, $Entry.LineNumber, $LineBelow)
       $Collider = $Entry.AdjacentSpaces

       foreach($LineNumber in $AdjacentLines){
           if($LineNumber -lt 0){
               continue
           }

           $WorkingLine = ($LineDataList[$LineNumber])

           foreach($ValidIndicies in $WorkingLine.NumberSpaces){
               $Var = (Compare-Object -ReferenceObject $ValidIndicies.Indicies -DifferenceObject $Collider -IncludeEqual -ExcludeDifferent)
               if($var){
                   $TotalValue += $ValidIndicies.Number
               }
           }
       }
   }

   return $TotalValue

}

# This one is fucked. I hate my life.
# function Invoke-AoCPart2 {
#    [CmdletBinding()]
#    param (
#        [Parameter(Mandatory)]
#        $Data
#    )
#
#    $TestData = (Get-Content $Data)
#
#    $JustAsterisks = "\*"
#    $AllNumbers = "\d+"
#
#    $LineDataList = [System.Collections.Generic.List[PSCustomObject]]::New()
#
#    $LineNumber = 0
#    $TotalValue = 0
#
#    foreach($Line in $TestData){
#        $AdjacentSpaces = [System.Collections.Generic.List[int]]::New()
#        $NumberSpaces = [System.Collections.Generic.List[PSCustomObject]]::New()
#
#        $Symbols = [regex]::Matches($Line, $JustAsterisks)
#        $Numbers = [regex]::Matches($Line, $AllNumbers)
#
#        foreach($Index in $Symbols.Index){
#            [Void]$AdjacentSpaces.Add($Index - 1)
#            [Void]$AdjacentSpaces.Add($Index)
#            [Void]$AdjacentSpaces.Add($Index + 1)
#        }
#
#        foreach($Number in $Numbers){
#            $StartIndex = $Number.Index
#            $EndIndex = ($Number.Index + $Number.Length) - 1
#
#            $NumberIndicies = $StartIndex..$EndIndex
#
#            $NumberData = [PSCustomObject]@{
#                Number = $Number.Value
#                Indicies = $NumberIndicies
#            }
#                
#            $NumberSpaces.Add($NumberData)
#        }
#
#        $LineData = [PSCustomObject]@{
#            LineNumber = $LineNumber
#            Symbols = $Symbols
#            Numbers = $Numbers
#            AdjacentSpaces = $AdjacentSpaces
#            NumberSpaces = $NumberSpaces
#        }
#
#        [Void]$LineDataList.Add($LineData)
#
#        $LineNumber++
#    }
#
#    foreach($Entry in $LineDataList){
#        $LineAbove = $Entry.LineNumber - 1
#        $LineBelow = $Entry.LineNumber + 1
#
#        $AdjacentLines = @($LineAbove, $Entry.LineNumber, $LineBelow)
#        $Collider = $Entry.AdjacentSpaces
#
#        $Cogs = [System.Collections.ArrayList]::New()
#
#        foreach($LineNumber in $AdjacentLines){
#            if($LineNumber -lt 0){
#                continue
#            }
#
#            $WorkingLine = ($LineDataList[$LineNumber])
#
#            foreach($ValidIndicies in $WorkingLine.NumberSpaces){
#                $Var = (Compare-Object -ReferenceObject $ValidIndicies.Indicies -DifferenceObject $Collider -IncludeEqual -ExcludeDifferent)
#                if($var){
#                    [Void]$Cogs.Add($ValidIndicies.Number)
#                }
#            }
#        }
#
#        if($Cogs.Count -eq 2){
#            $Number1 = [int]$Cogs[0]
#            $Number2 = [int]$Cogs[1]
#
#            $Ratio = ($Number1 * $Number2)
#
#            $TotalValue += $Ratio
#        }
#    }
#
#    return $TotalValue
#
# }

function Invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data,
        $RegexMatches
    )

    $TestData = (Get-Content $Data)

    $TotalPartNumber = 0

    $SearchBox = @(-1, 0, 1)

    $TestDataY = $TestData.Length
    $TestDataX = $TestData[0].Length

    for($Y = 0; ($Y -lt $TestDataY); $Y++){
        for($X = 0; ($X -lt $TestDataX); $X++){
            $Char = $TestData[$Y][$X]

            if($Char -notmatch $RegexMatches){
                continue
            }

            $SearchAroundSplat = @{
                TestData = $TestData
                SearchBox = $SearchBox
                RegexMatches = $RegexMatches
                x = $X
                y = $Y
            }

            $PartNumbers = (Search-Around @SearchAroundSplat)

            foreach($PartNumber in $PartNumbers){
                $TotalPartNumber += $PartNumber
            }

        }
    }

    return $TotalPartNumber
}

function Invoke-AoCPart2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data,
        $RegexMatches
    )

    $TestData = (Get-Content $Data)

    $TotalRatio = 0

    $SearchBox = @(-1, 0, 1)

    $TestDataY = $TestData.Length
    $TestDataX = $TestData[0].Length

    for($Y = 0; ($Y -lt $TestDataY); $Y++){
        for($X = 0; ($X -lt $TestDataX); $X++){
            $Char = $TestData[$Y][$X]

            if($Char -notmatch $RegexMatches){
                continue
            }

            $SearchAroundSplat = @{
                TestData = $TestData
                SearchBox = $SearchBox
                RegexMatches = $RegexMatches
                x = $X
                y = $Y
            }

            $AdjacentNumbers = (Search-Around @SearchAroundSplat)

            if($AdjacentNumbers.Count -eq 2){
                $GearRatio = ($AdjacentNumbers[0] * $AdjacentNumbers[1])

                $TotalRatio += $GearRatio
            }
        }
    }

    return $TotalRatio
}


function Search-Around {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $TestData,
        [Parameter(Mandatory)]
        $SearchBox,
        [Parameter(Mandatory)]
        $RegexMatches,
        [Parameter(Mandatory)]
        $X,
        [Parameter(Mandatory)]
        $Y
    )

    $AdjacentNumbers = [System.Collections.Generic.List[int]]::New()

    foreach($RelativeX in $SearchBox){
        foreach($RelativeY in $SearchBox){
            $SearchChar = $TestData[($Y + $RelativeY)][($X + $RelativeX)]
            
            if($SearchChar -match "\d"){
                $Coordinates = @{
                    Y = ($Y + $RelativeY)
                    X = ($X + $RelativeX)
                }

                $Number = (Find-Number $TestData $Coordinates)

                if($AdjacentNumbers -notcontains $Number){
                    $AdjacentNumbers.Add($Number)
                }
            }
        }
    }

    return $AdjacentNumbers
}

function Find-Number {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Data,
        [Parameter(Mandatory)]
        $DigitCoordinate
    )

    $Digits = [System.Collections.Generic.List[string]]::New()

    $Y = $DigitCoordinate.Y

    $FoundDigit = 0
    $Offset = 0

    #Go Left
    while($FoundDigit -match "\d"){
        $X = ($DigitCoordinate.X - $OffSet)
        $FoundDigit = $Data[$Y][$X]

        if($FoundDigit -match "\d"){
            $Digits.Add([string]$FoundDigit)
        }

        $Offset++
    }

    $Digits.Reverse()

    $Offset = 1
    $FoundDigit = 0

    #Go Right
    while($FoundDigit -match "\d"){
        $X = ($DigitCoordinate.X + $OffSet)
        $FoundDigit = $Data[$Y][$X]

        if($FoundDigit -match "\d"){
            $Digits.Add([string]$FoundDigit)
        }

        $Offset++
    }

    return [int]($Digits -Join "")
}