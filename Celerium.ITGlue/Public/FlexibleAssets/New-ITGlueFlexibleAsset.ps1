function New-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        Creates one or more flexible assets

    .DESCRIPTION
        The New-ITGlueFlexibleAsset cmdlet creates one or more
        flexible assets

        If there are any required fields in the flexible asset type,
        they will need to be included in the request

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The organization id to create the flexible asset in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueFlexibleAsset -OrganizationID 8675309 -Data $JsonBody

        Creates a new flexible asset in the defined organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/New-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Create', Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Create', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Create'   { $ResourceUri = "/organizations/$OrganizationID/relationships/flexible_assets" }
            'Create'        { $ResourceUri = '/flexible_assets' }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
