[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    $CalorieFile
)

begin {
    $CalorieList = (Get-Content $CalorieFile)

    $HighestCalorie = 0
}

process {
    foreach($Item in $CalorieList){
        if([String]::IsNullOrWhiteSpace($Item)){

            if($CurrentCalories -ge $HighestCalorie){
                $HighestCalorie = $CurrentCalories
            }

            $CurrentCalories = 0
            continue
        }

        $CurrentCalories += [int]$Item
    }
}

end {
    return $HighestCalorie
}