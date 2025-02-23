function Set-ITGlueOrganization {
<#
    .SYNOPSIS
        Updates one or more organizations

    .DESCRIPTION
        The Set-ITGlueOrganization cmdlet updates the details of an
        existing organization or multiple organizations

        Any attributes you don't specify will remain unchanged

        Returns 422 Bad Request error if trying to update an externally synced record on
        attributes other than: alert, description, quick_notes

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update an organization by id

    .PARAMETER FilterID
        Filter by an organization id

    .PARAMETER FilterName
        Filter by an organization name

    .PARAMETER FilterOrganizationTypeID
        Filter by an organization type id

    .PARAMETER FilterOrganizationStatusID
        Filter by an organization status id

    .PARAMETER FilterCreatedAt
        Filter by when an organization created

    .PARAMETER FilterUpdatedAt
        Filter by when an organization updated

    .PARAMETER FilterMyGlueAccountID
        Filter by a MyGlue id

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterGroupID
        Filter by a group id

    .PARAMETER FilterPrimary
        Filter for primary organization

        Allowed values:
        'true', 'false'

    .PARAMETER FilterExcludeID
        Filter to excluded a certain organization id

    .PARAMETER FilterExcludeName
        Filter to excluded a certain organization name

    .PARAMETER FilterExcludeOrganizationTypeID
        Filter to excluded a certain organization type id

    .PARAMETER FilterExcludeOrganizationStatusID
        Filter to excluded a certain organization status id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueOrganization -id 8765309 -Data $JsonBody

        Updates an organization with the specified JSON body

    .EXAMPLE
        Set-ITGlueOrganization -FilterOrganizationStatusID 12345 -Data $JsonBody

        Updates all defined organization with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Set-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
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
            'Bulk*'     { $ResourceUri = "/organizations" }
            'Update'    { $ResourceUri = "/organizations/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update*') {
            if ($FilterID)                          { $query_params['filter[id]']                                = $FilterID }
            if ($FilterName)                         { $query_params['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)           { $query_params['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)         { $query_params['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                    { $query_params['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                    { $query_params['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)              { $query_params['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)           { $query_params['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                      { $query_params['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                      { $query_params['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                    { $query_params['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                  { $query_params['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)    { $query_params['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID)  { $query_params['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update_PSA') {
            if ($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
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
