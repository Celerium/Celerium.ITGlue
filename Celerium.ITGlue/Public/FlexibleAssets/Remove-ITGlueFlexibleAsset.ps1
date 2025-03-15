function Remove-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        Deletes one or more a flexible assets

    .DESCRIPTION
        The Remove-ITGlueFlexibleAsset cmdlet destroys multiple or a single
        flexible asset

    .PARAMETER ID
        The flexible asset id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueFlexibleAsset -id 8675309

        Deletes the defined flexible asset

    .EXAMPLE
        Remove-ITGlueFlexibleAsset -Data $JsonBody

        Deletes flexible asset defined in the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Remove-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'BulkDestroy'  { $ResourceUri = "/flexible_assets" }
            'Destroy'       { $ResourceUri = "/flexible_assets/$ID" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
