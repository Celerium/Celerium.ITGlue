function Set-ITGlueConfiguration {
<#
    .SYNOPSIS
        Updates one or more configurations

    .DESCRIPTION
        The Set-ITGlueConfiguration cmdlet updates the details
        of one or more existing configurations

        Any attributes you don't specify will remain unchanged

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER OrganizationID
        A valid organization Id in your account

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
        'pulseway-rmm', 'syncro', 'watchman-monitoring'

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueConfiguration -ID 8765309 -OrganizationID 8765309 -Data $JsonBody

        Updates a defined configuration in the defined organization with
        the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Set-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'BulkUpdateRMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'BulkUpdateRMM')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdatermm', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdatepsa', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdateRMMPSA', Mandatory = $true)]
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
            'BulkUpdate*'  { $ResourceUri = "/configurations" }
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations/$ID"}
                    $false  { $ResourceUri = "/configurations/$ID" }
                }

            }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'BulkUpdate*') {
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

        if ($PSCmdlet.ParameterSetName -like 'BulkUpdateRMM*') {
            if ($FilterRmmID) {$UriParameters['filter[rmm_id]'] = $FilterRmmID}
        }
        if ($PSCmdlet.ParameterSetName -like '*PSA') {
            if ($FilterPsaID) {$UriParameters['filter[psa_id]'] = $FilterPsaID}
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
