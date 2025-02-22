function Get-ITGlueLocation {
<#
    .SYNOPSIS
        List or show all location

    .DESCRIPTION
        The Get-ITGlueLocation cmdlet returns a list of locations for
        all organizations or for a specified organization

        This function can call the following endpoints:
            Index = /locations
                    /organizations/:$OrganizationID/relationships/locations

            Show =  /locations/:id
                    /organizations/:id/relationships/locations/:id

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER FilterID
        Filter by a location id

    .PARAMETER FilterName
        Filter by a location name

    .PARAMETER FilterCity
        Filter by a location city

    .PARAMETER FilterRegionID
        Filter by a location region id

    .PARAMETER FilterCountryID
        Filter by a location country id

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a psa integration id

    .PARAMETER FilterPsaIntegrationType
        Filter by a psa integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

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

    .PARAMETER ID
        Get a location by id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, group_resource_accesses,
        passwords ,user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        recent_versions ,related_items ,authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueLocation

        Returns the first 50 location results from your ITGlue account

    .EXAMPLE
        Get-ITGlueLocation -ID 8765309

        Returns the location with the defined id

    .EXAMPLE
        Get-ITGlueLocation -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for locations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Get-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources', 'attachments', 'group_resource_accesses', 'passwords',
                        'user_resource_accesses', 'recent_versions', 'related_items', 'authorized_users'
        )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Index*'   {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations" }
                    $false  { $ResourceUri = "/locations" }
                }

            }
            'Show'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
                    $false  { $ResourceUri = "/locations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if (($PSCmdlet.ParameterSetName -like 'Index*')) {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $query_params['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $query_params['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $query_params['filter[country_id]']            = $FilterCountryID }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
            if ($Sort)                      { $query_params['sort']                         = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Index_PSA') {
            $query_params['filter[psa_id]'] = $FilterPsaID
        }

        if($Include) {
            $query_params['include'] = $Include
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
