function New-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Creates one or more flexible asset fields

    .DESCRIPTION
        The New-ITGlueFlexibleAssetField cmdlet creates one or more
        flexible asset field for a particular flexible asset type

    .PARAMETER FlexibleAssetTypeID
        The flexible asset type id to create a new field in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueFlexibleAssetField -FlexibleAssetTypeID 8675309 -Data $JsonBody

        Creates a new flexible asset field for the defined id with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/New-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$FlexibleAssetTypeID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$FlexibleAssetTypeID) {
            $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields" }
            $false  { $ResourceUri = "/flexible_asset_fields" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
