function Import-TestData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Get-Content $Path)

    $DataCount  = ($Data.Count)
    $Directions = ([char[]]$Data[0])

    $DecisionRegex  = "(\S+) = \((\S+)\, (\S+)\)"
    $DecisionList   = [System.Collections.Generic.List[PSCustomObject]]::New()
    $StartingList   = [System.Collections.Generic.List[PSCustomObject]]::New()

    for($Line = 2; $Line -lt $DataCount; $Line++){
        $Decision = [regex]::Matches($Data[$Line], $DecisionRegex)

        $Index = $Decision.Groups[1].Value
        $Left = $Decision.Groups[2].Value
        $Right = $Decision.Groups[3].Value

        $DecisionArray = @($Left, $Right)

        $DecisionList.Add($DecisionArray)
        $StartingList.Add($Index)
    }

    return $Directions, $StartingList, $DecisionList
}

function invoke-AoCPart1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Import-TestData $Path)

    $CurrentLocation    = ""
    $MovementCount      = 0

    $Directions = $Data[0]
    $Location   = $Data[1]
    $Decision   = $Data[2]
    

    while($CurrentLocation -ne "ZZZ"){

    }
}