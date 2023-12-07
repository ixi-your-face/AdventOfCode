function ImportChallengeFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    $Data = (GetContent $Path)

    $DigitRegex = "\d+"
    $HeaderRegex = "^(.*):$"

    #region Seed Processing
    $SeedRow = [regex]::Matches($Data[0], $DigitRegex)

    foreach ($Seed in $SeedRow) {
        $Seeds.Add($Seed)
    }
    #endregion

    #region Find Headers Of Maps
    for ($Line = 0; $Line -lt ($Data.Length); $Line++) {
        $Header = [regex]::Matches($Data[$Line], $HeaderRegex)
        if ($Header.Success) {
            $Header, $Line
        }
    }

    #endregion

    $Output = [PSCustomObject]@{
        Seeds                 = $Seeds
        SeedToSoill           = $SeedToSoil
        SoilToFertilizer      = $SoilToFertilizer
        FertilizerToWater     = $FertilizerToWater
        WaterToLight          = $WaterToLight
        LightToTemperature    = $LightToTemperature
        TemperatureToHumidity = $TemperatureToHumidity
        HumidityToLocation    = $HumidityToLocation
    }

    retrun $Output
}