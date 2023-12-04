[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    $CalorieFile
)

begin {
    $CalorieList = (Get-Content $CalorieFile)

    $ElfArray = [System.Collections.ArrayList]@()
}

process {
    foreach($Item in $CalorieList){
        if([String]::IsNullOrWhiteSpace($Item)) {

            [Void]$ElfArray.Add($CurrentCalories)

            $CurrentCalories = 0
            continue
        }

        $CurrentCalories += [int]$Item
    }
}

end {
    $ElfArray.Sort()
    $ElfArray.Reverse()

    $ElfArray[0..2] | ForEach-Object{ $Top3 += $_ }
    
    Write-Host $ElfArray[0..2]
    return $Top3
}