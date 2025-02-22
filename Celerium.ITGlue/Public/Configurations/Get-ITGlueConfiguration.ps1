function Get-ITGlueConfiguration {
<#
    .SYNOPSIS
        List all configurations in an account or organization

    .DESCRIPTION
        The Get-ITGlueConfiguration cmdlet lists all configurations
        in an account or organization

        This function can call the following endpoints:
            Index = /configurations
                    /organizations/:organization_id/relationships/configurations

            Show =  /configurations/:id
                    /organizations/:organization_id/relationships/configurations/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

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

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated-at',
        '-name', '-id', '-created_at', '-updated-at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, tickets ,configuration_interfaces,
        dnet_fa_remote_assets, group_resource_accesses ,rmm_records, passwords,
        user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        active_network_glue_network_devices ,adapters_resources_errors ,authorized_users
        from_configuration_connections, recent_versions, related_items ,rmm_adapters_resources
        rmm_adapters_resources_errors, to_configuration_connections

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueConfigurations

        Returns the first 50 configurations from your ITGlue account

    .EXAMPLE
        Get-ITGlueConfiguration -FilterOrganizationID 8765309

        Returns the first 50 configurations from the defined organization

    .EXAMPLE
        Get-ITGlueConfiguration -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for configurations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Get-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true ,Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Index_RMM_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated-at',
                        '-name', '-id', '-created_at', '-updated-at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'active_network_glue_network_devices', 'adapters_resources', 'adapters_resources_errors',
                        'attachments', 'authorized_users', 'configuration_interfaces', 'dnet_fa_remote_assets',
                        'from_configuration_connections', 'group_resource_accesses', 'passwords', 'recent_versions',
                        'related_items', 'rmm_adapters_resources', 'rmm_adapters_resources_errors', 'rmm_records',
                        'tickets', 'to_configuration_connections', 'user_resource_accesses'
        )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
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
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations"}
                    $false  { $ResourceUri = "/configurations" }
                }

            }
            'Show'      {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations/$ID"}
                    $false  { $ResourceUri = "/configurations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Index*') {
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
            if ($Sort)                          { $query_params['sort']                             = $Sort }
            if ($PageNumber)                    { $query_params['page[number]']                     = $PageNumber }
            if ($PageSize)                      { $query_params['page[size]']                       = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -like 'Index_RMM*') {
                $query_params['filter[rmm_id]'] = $FilterRmmID
        }
        if ($PSCmdlet.ParameterSetName -like '*_PSA') {
                $query_params['filter[psa_id]'] = $FilterPsaID
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
