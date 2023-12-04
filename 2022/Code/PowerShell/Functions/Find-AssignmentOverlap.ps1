[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    $AssignmentFile
)

begin {
    $AssignmentList = (Get-Content $AssignmentFile)

    $ContainingAssignments = 0
}

process {
    foreach($AssignmentPair in $AssignmentList){
        $Group1 = $AssignmentPair.Split(',')[0]
        $Group2 = $AssignmentPair.Split(',')[1]

        $Group1 = ($Group1.Split('-')[0])..($Group1.Split('-')[1])
        $Group2 = ($Group2.Split('-')[0])..($Group2.Split('-')[1])

        if($Group1.Count -ge $Group2.Count){
            $Bigger = $Group1
            $Smaller = $Group2
        } else {
            $Bigger = $Group2
            $Smaller = $Group1
        }

        $CompareSplat = @{
            ReferenceObject = $Bigger
            DifferenceObject = $Smaller
            IncludeEqual = $true
            ExcludeDifferent = $true
        }

        $Compare = (Compare-Object @CompareSplat).InputObject

        if($Compare.Count -gt 0){
            $ContainingAssignments++
        }
    }
}

end {
    return $ContainingAssignments
}