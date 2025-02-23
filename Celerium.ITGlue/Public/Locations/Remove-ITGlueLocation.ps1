function Remove-ITGlueLocation {
<#
    .SYNOPSIS
        Deletes one or more locations

    .DESCRIPTION
        The Set-ITGlueLocation cmdlet deletes one or more
        specified locations

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER ID
        Location id

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
        Remove-ITGlueLocation -OrganizationID 123456 -ID 8765309 -Data $JsonBody

        Removes the defined location from the defined organization with the specified JSON body

    .EXAMPLE
        Remove-ITGlueLocation -Data $JsonBody

        Removes location(s) with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Remove-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
            $false  { $ResourceUri = "/locations" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $query_params['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $query_params['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $query_params['filter[country_id]']           = $FilterCountryID }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy_PSA') {
            $query_params['filter[psa_id]'] = $FilterPsaID
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
