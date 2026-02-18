function Remove-ITGlueConfiguration {
<#
    .SYNOPSIS
        Deletes one or more configurations

    .DESCRIPTION
        The Remove-ITGlueConfiguration cmdlet deletes one or
        more specified configurations

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER FilterID
        Filter by configuration id

    .PARAMETER FilterName
        Filter by configuration name

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterConfigurationTypeID
        Filter by configuration type id

    .PARAMETER FilterConfigurationStatusID
        Filter by configuration status id

    .PARAMETER FilterContactID
        Filter by contact id

    .PARAMETER FilterSerialNumber
        Filter by a configurations serial number

    .PARAMETER FilterMacAddress
        Filter by a configurations mac address

    .PARAMETER FilterAssetTag
        Filter by a configurations asset tag

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterRmmID
        Filter by a RMM id

    .PARAMETER FilterRmmIntegrationType
        Filter by a RMM integration type

        Allowed values:
        'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueConfiguration -ID 8765309 -Data $JsonBody

        Deletes a defined configuration with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Remove-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'BulkDestroyRMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'BulkDestroyRMM')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyRMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyPSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroyRMMPSA', Mandatory = $true)]
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
            $true   { $ResourceUri = "/configurations/$OrganizationID/relationships/configurations" }
            $false  { $ResourceUri = "/configurations" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                      { $UriParameters['filter[id]']                       = $FilterID }
            if ($FilterName)                    { $UriParameters['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)          { $UriParameters['filter[organization_id]']          = $FilterOrganizationID }
            if ($FilterConfigurationTypeID)     { $UriParameters['filter[configuration_type_id]']    = $FilterConfigurationTypeID }
            if ($FilterConfigurationStatusID)   { $UriParameters['filter[configuration_status_id]']  = $FilterConfigurationStatusID }
            if ($FilterContactID)               { $UriParameters['filter[contact_id]']               = $FilterContactID }
            if ($FilterSerialNumber)            { $UriParameters['filter[serial_number]']            = $FilterSerialNumber }
            if ($FilterMacAddress)              { $UriParameters['filter[mac_address]']              = $FilterMacAddress }
            if ($FilterAssetTag)                { $UriParameters['filter[asset_tag]']                = $FilterAssetTag }
            if ($FilterPsaIntegrationType)      { $UriParameters['filter[psa_integration_type]']     = $FilterPsaIntegrationType }
            if ($FilterRmmIntegrationType)      { $UriParameters['filter[rmm_integration_type]']     = $FilterRmmIntegrationType }
            if ($FilterArchived)                { $UriParameters['filter[archived]']                 = $FilterArchived }
        }

        if ($PSCmdlet.ParameterSetName -like 'BulkDestroyRMM*') {
            if ($FilterRmmID) {$UriParameters['filter[rmm_id]'] = $FilterRmmID}
        }
        if ($PSCmdlet.ParameterSetName -like '*PSA') {
            if ($FilterPsaID) {$UriParameters['filter[psa_id]'] = $FilterPsaID}
        }

        if ($PSCmdlet.ParameterSetName -eq 'Destroy') {
            $Data = @(
                @{
                    type = 'configurations'
                    attributes = @{
                        id = $ID
                    }
                }
            )
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
