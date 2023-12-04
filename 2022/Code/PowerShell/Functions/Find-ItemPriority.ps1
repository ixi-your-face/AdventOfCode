[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    $RuckSackContents
)

begin {
    $RuckSackContents = (Get-Content $RuckSackContents)

    $AlphabetArray = @(
        [char[]]('a'[0]..'z'[0]) + [char[]]('A'[0]..'Z'[0])
    )

    $TotalPriority = 0

    $SameItemsArray = [System.Collections.ArrayList]@()
}

process {
    foreach($Rucksack in $RuckSackContents){
        $ItemsInRucksack = ($Rucksack.Length)
        $CompartmentSize = ($ItemsInRucksack / 2)

        $Compartment1 = ($Rucksack[0..($CompartmentSize - 1)])
        $Compartment2 = ($Rucksack[$CompartmentSize..($ItemsInRucksack - 1)])

        $CompareSplat = @{
            ReferenceObject = $Compartment1
            DifferenceObject = $Compartment2
            IncludeEqual = $true
            ExcludeDifferent = $true
        }

        $SameItems = (Compare-Object @CompareSplat).InputObject | select-Object -Unique
        Write-Host $SameItems

        foreach($Item in $SameItems){
            [Void]$SameItemsArray.Add($Item)
        }
    }

    foreach($Item in $SameItemsArray){
        $TotalPriority += ($AlphabetArray.IndexOf([char]$Item) + 1)
    }
}

end {
    return $TotalPriority
}