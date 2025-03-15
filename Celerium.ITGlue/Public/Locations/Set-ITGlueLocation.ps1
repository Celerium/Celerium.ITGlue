function Set-ITGlueLocation {
<#
    .SYNOPSIS
        Updates one or more a locations

    .DESCRIPTION
        The Set-ITGlueLocation cmdlet updates the details of
        an existing location or locations

        Any attributes you don't specify will remain unchanged

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Get a location by id

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

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueLocation -id 8765309 -Data $JsonBody

        Updates the defined location with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Set-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

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

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'BulkUpdate*'  { $ResourceUri = "/locations" }
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
                    $false  { $ResourceUri = "/locations/$ID" }
                }

            }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdate') {
            if ($FilterID)                  { $UriParameters['filter[id]']                   = $FilterID }
            if ($FilterName)                { $UriParameters['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $UriParameters['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $UriParameters['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $UriParameters['filter[country_id]']            = $FilterCountryID }
            if ($FilterOrganizationID)      { $UriParameters['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $UriParameters['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdatePSA') {
            $UriParameters['filter[psa_id]'] = $FilterPsaID
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
