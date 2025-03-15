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

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [Parameter(ParameterSetName = 'BulkUpdatePSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdatePSA', Mandatory = $true)]
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

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'BulkUpdate*') {
            if ($FilterID)                          { $UriParameters['filter[id]']                                = $FilterID }
            if ($FilterName)                         { $UriParameters['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)           { $UriParameters['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)         { $UriParameters['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                    { $UriParameters['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                    { $UriParameters['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)              { $UriParameters['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)           { $UriParameters['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                      { $UriParameters['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                      { $UriParameters['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                    { $UriParameters['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                  { $UriParameters['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)    { $UriParameters['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID)  { $UriParameters['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
        }

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdatePSA') {
            if ($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
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
