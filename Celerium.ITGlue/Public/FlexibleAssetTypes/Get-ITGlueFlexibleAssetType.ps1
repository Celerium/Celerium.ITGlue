function Get-ITGlueFlexibleAssetType {
<#
    .SYNOPSIS
        List or show all flexible asset types

    .DESCRIPTION
        The Get-ITGlueFlexibleAssetType cmdlet returns details on a flexible asset type
        or a list of flexible asset types in your account

        This function can call the following endpoints:
            Index = /flexible_asset_types

            Show =  /flexible_asset_types/:id

    .PARAMETER FilterID
        Filter by a flexible asset id

    .PARAMETER FilterName
        Filter by a flexible asset name

    .PARAMETER FilterIcon
        Filter by a flexible asset icon

    .PARAMETER FilterEnabled
        Filter if a flexible asset is enabled

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values:
        'flexible_asset_fields'

    .PARAMETER ID
        A valid flexible asset id in your account

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueFlexibleAssetType

        Returns the first 50 flexible asset results from your ITGlue account

    .EXAMPLE
        Get-ITGlueFlexibleAssetType -ID 8765309

        Returns the defined flexible asset with the defined id

    .EXAMPLE
        Get-ITGlueFlexibleAssetType -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for flexible assets
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Get-ITGlueFlexibleAssetType.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-types-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterIcon,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('true', 'false')]
        [string]$FilterEnabled,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('flexible_asset_fields')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/flexible_asset_types" }
            'Show'  { $ResourceUri = "/flexible_asset_types/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']       = $FilterID }
            if ($FilterName)    { $query_params['filter[name]']     = $FilterName }
            if ($FilterIcon)    { $query_params['filter[icon]']     = $FilterIcon }
            if ($FilterEnabled) { $query_params['filter[enabled]']  = $FilterEnabled }
            if ($Sort)          { $query_params['sort']             = $Sort }
            if ($PageNumber)    { $query_params['page[number]']     = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']       = $PageSize }
        }

        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
