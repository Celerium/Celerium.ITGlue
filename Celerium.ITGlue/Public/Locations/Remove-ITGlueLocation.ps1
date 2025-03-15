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

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyPSA', Mandatory = $true)]
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

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                  { $UriParameters['filter[id]']                   = $FilterID }
            if ($FilterName)                { $UriParameters['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $UriParameters['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $UriParameters['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $UriParameters['filter[country_id]']           = $FilterCountryID }
            if ($FilterOrganizationID)      { $UriParameters['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $UriParameters['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'BulkDestroyPSA') {
            $UriParameters['filter[psa_id]'] = $FilterPsaID
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -UriFilter $UriParameters -Data $Data
        }

    }

    end {}

}
