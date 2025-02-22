function Remove-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Delete a flexible asset field

    .DESCRIPTION
        The Remove-ITGlueFlexibleAssetField cmdlet deletes a flexible asset field

        Note that this action will cause data loss if the field is already in use

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer


    .PARAMETER ID
        Id of a flexible asset field

    .PARAMETER FlexibleAssetTypeID
        A flexible asset type Id in your Account

    .EXAMPLE
        Remove-ITGlueFlexibleAssetField -id 8675309

        Deletes a defined flexible asset field and any data associated to that
        field

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Remove-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter()]
        [int64]$FlexibleAssetTypeID,

        [Parameter(Mandatory = $true)]
        [int64]$ID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$FlexibleAssetTypeID) {
            $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields/$ID" }
            $false  { $ResourceUri = "/flexible_asset_fields/$ID" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
