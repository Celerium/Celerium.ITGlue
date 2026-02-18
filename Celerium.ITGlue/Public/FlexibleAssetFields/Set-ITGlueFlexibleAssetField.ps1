function Set-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Updates one or more flexible asset fields

    .DESCRIPTION
        The Set-ITGlueFlexibleAssetField cmdlet updates the details of one
        or more existing flexible asset fields

        Any attributes you don't specify will remain unchanged

        Can also be used to bulk update flexible asset fields

        Returns 422 error if trying to change the kind attribute of fields that
        are already in use

    .PARAMETER FlexibleAssetTypeID
        A valid Flexible asset Id in your Account

    .PARAMETER ID
        Id of a flexible asset field

    .PARAMETER FilterID
        Filter by a flexible asset field id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueFlexibleAssetField -id 8675309 -Data $JsonBody

        Updates a defined flexible asset field with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Set-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$FlexibleAssetTypeID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'BulkUpdate'   { $ResourceUri = "/flexible_asset_fields" }
            'Update'        {

                switch ([bool]$FlexibleAssetTypeID) {
                    $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields/$ID"}
                    $false  { $ResourceUri = "/flexible_asset_fields/$ID" }
                }

            }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdate') {
            if ($FilterID) { $UriParameters['filter[id]'] = $FilterID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -UriFilter $UriParameters -Data $Data
        }

    }

    end {}

}
