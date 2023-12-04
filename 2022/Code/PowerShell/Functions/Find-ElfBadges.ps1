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

    $BadgesArray = [System.Collections.ArrayList]@()

    $Groups = [System.Collections.ArrayList]@()
    $Group = [System.Collections.ArrayList]@()
}

process {

    foreach($Rucksack in $RuckSackContents){
        [Void]$Group.Add($Rucksack)
        
        if($Group.Count -eq 3){
            [Void]$Groups.Add($Group)
            $Group = [System.Collections.ArrayList]@()
        }
    }

    foreach($Group in $Groups){
        $Elf1 = $Group[0].ToCharArray()
        $Elf2 = $Group[1].ToCharArray()
        $Elf3 = $Group[2].ToCharArray()

        $Compare1 = (Compare-Object -ReferenceObject $Elf1 -DifferenceObject $Elf2 -ExcludeDifferent -IncludeEqual -CaseSensitive).InputObject | Sort-Object -Unique
        $Compare2 = (Compare-Object -ReferenceObject $Elf2 -DifferenceObject $Elf3 -ExcludeDifferent -IncludeEqual -CaseSensitive).InputObject | Sort-Object -Unique
        $Badges = (Compare-Object -ReferenceObject $Compare1 -DifferenceObject $Compare2 -ExcludeDifferent -IncludeEqual -CaseSensitive).InputObject | Sort-Object -Unique

        foreach($Badge in $Badges){
            [Void]$BadgesArray.Add($Badge)
        }
    }

    foreach($Item in $BadgesArray){
        $TotalPriority += ($AlphabetArray.IndexOf([char]$Item) + 1)
    }
}

end {
    return $TotalPriority
}