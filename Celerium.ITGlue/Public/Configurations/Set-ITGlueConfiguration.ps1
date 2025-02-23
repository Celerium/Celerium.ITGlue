function Set-ITGlueConfiguration {
<#
    .SYNOPSIS
        Updates one or more configurations

    .DESCRIPTION
        The Set-ITGlueConfiguration cmdlet updates the details
        of one or more existing configurations

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update = /configurations/:id
                    /organizations/:organization_id/relationships/configurations/:id

            Bulk_Update =  /configurations

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

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
        https://api.itglue.com/developer/#configurations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_rmm', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_psa', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_rmm_psa', Mandatory = $true)]
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
            'Bulk_Update*'  { $ResourceUri = "/configurations" }
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations/$ID"}
                    $false  { $ResourceUri = "/configurations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update*') {
            if ($FilterID)                      { $query_params['filter[id]']                       = $FilterID }
            if ($FilterName)                    { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)          { $query_params['filter[organization_id]']          = $FilterOrganizationID }
            if ($FilterConfigurationTypeID)     { $query_params['filter[configuration_type_id]']    = $FilterConfigurationTypeID }
            if ($FilterConfigurationStatusID)   { $query_params['filter[configuration_status_id]']  = $FilterConfigurationStatusID }
            if ($FilterContactID)               { $query_params['filter[contact_id]']               = $FilterContactID }
            if ($FilterSerialNumber)            { $query_params['filter[serial_number]']            = $FilterSerialNumber }
            if ($FilterMacAddress)              { $query_params['filter[mac_address]']              = $FilterMacAddress }
            if ($FilterAssetTag)                { $query_params['filter[asset_tag]']                = $FilterAssetTag }
            if ($FilterPsaIntegrationType)      { $query_params['filter[psa_integration_type]']     = $FilterPsaIntegrationType }
            if ($FilterRmmIntegrationType)      { $query_params['filter[rmm_integration_type]']     = $FilterRmmIntegrationType }
            if ($FilterArchived)                { $query_params['filter[archived]']                 = $FilterArchived }
        }

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update_RMM*') {
            if ($FilterRmmID) {$query_params['filter[rmm_id]'] = $FilterRmmID}
        }
        if ($PSCmdlet.ParameterSetName -like '*_PSA') {
            if ($FilterPsaID) {$query_params['filter[psa_id]'] = $FilterPsaID}
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
