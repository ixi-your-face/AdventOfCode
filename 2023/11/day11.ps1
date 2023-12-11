function Import-TestData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Get-Content $Path)

    return $Data
}

function Expand-Universe {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Universe
    )

    
    return $ExpandedUniverse
}