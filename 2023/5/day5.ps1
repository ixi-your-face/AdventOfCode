function Import-ChallengeData{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (Get-Content $Path)

    $Mappings       = [System.Collections.ArrayList]::New()
    $WhiteLineRegex = "^$"
    $NumbersRegex   = "\d+"
    $WordsRegex     = "[a-z-]"

    $Seeds = ([regex]::Matches($Data[0], $NumbersRegex)).Value

    for($Line = 2; $Line -lt ($Data.Length); $Line++){

        $Text  = ([regex]::Match($Data[$Line],$WordsRegex))
        $WhiteLine  = ([regex]::Match($Data[$Line],$WhiteLineRegex))

        if($Text.Success){
            $Mapping = [System.Collections.ArrayList]::New()
            continue
        }

        if($WhiteLine.Success){
            [void]$Mappings.Add($Mapping)
            continue
        }

        $Numbers = ([regex]::Matches($Data[$Line], $NumbersRegex)).Value
        
        $RangeNumber            = [bigint]($Numbers[2] - 1)

        $SourceNumberStart      = [bigint]$Numbers[1]
        $SourceNumberEnd        = [bigint]($SourceNumberStart + $RangeNumber)

        $DestinationNumberStart = [bigint]$Numbers[0]
        $DestinationNumberEnd   = [bigint]($DestinationNumberStart + $RangeNumber)

        $MappingData = [PSCustomObject]@{
            SourceRange         = @($SourceNumberStart, $SourceNumberEnd)
            Destinationrange    = @($DestinationNumberStart, $DestinationNumberEnd)
        }

        [void]$Mapping.Add($MappingData)
    }

    $OutputData = [PSCustomObject]@{
        Seeds = $Seeds
        Mappings = $Mappings
    }

    return $OutputData
}

function Find-SoilNumber {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ParsedInput
    )

    $Seeds = $ParsedInput.Seeds
    $Mappings = $ParsedInput.Mappings

    foreach($Seed in $Seeds){
        $CurrentNumber = $Seed

        foreach($Mapping in $Mappings){
            foreach($Range in $Mappings){
                

                if(($Number -gt $StartDigit) -and ($Number -lt $EndDigit)){

                }
            }
        }
    }
}