function Get-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        List or show all flexible assets

    .DESCRIPTION
        The Get-ITGlueFlexibleAsset cmdlet returns a list of flexible assets or
        the details of a single flexible assets based on the unique ID of the
        flexible asset type

        This function can call the following endpoints:
            Index = /flexible_assets

            Show =  /flexible_assets/:id

    .PARAMETER FilterFlexibleAssetTypeID
        Filter by a flexible asset id

        This is the flexible assets id number you see in the URL under an organizations

    .PARAMETER FilterName
        Filter by a flexible asset name

    .PARAMETER FilterOrganizationID
        Filter by a organization id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at',
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, distinct_remote_assets, group_resource_accesses
        passwords, user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        authorized_users, recent_versions, related_items

    .PARAMETER ID
        Get a flexible asset id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309

        Returns the first 50 results for the defined flexible asset

    .EXAMPLE
        Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309 -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for the defined
        flexible asset

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Get-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', Mandatory = $true)]
        [int64]$FilterFlexibleAssetTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources', 'attachments', 'authorized_users', 'distinct_remote_assets',
                        'group_resource_accesses', 'passwords', 'recent_versions','related_items',
                        'user_resource_accesses'
        )]
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
            'Index' { $ResourceUri = "/flexible_assets" }
            'Show'  { $ResourceUri = "/flexible_assets/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterFlexibleAssetTypeID) { $query_params['filter[flexible-asset-type-id]']   = $FilterFlexibleAssetTypeID }
            if ($FilterName)                { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)      { $query_params['filter[organization-id]']          = $FilterOrganizationID }
            if ($Sort)                      { $query_params['sort']                             = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                     = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                       = $PageSize }
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
