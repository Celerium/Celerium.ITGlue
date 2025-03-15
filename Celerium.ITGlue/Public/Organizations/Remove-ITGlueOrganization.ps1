function Remove-ITGlueOrganization {
<#
    .SYNOPSIS
        Deletes one or more organizations

    .DESCRIPTION
        The Remove-ITGlueOrganization cmdlet marks organizations identified by the
        specified organization IDs for deletion

        Because it can be a long procedure to delete organizations,
        removal from the system may not happen immediately

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

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
        Remove-ITGlueOrganization -Data $JsonBody

        Deletes all defined organization with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Remove-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyPSA')]
        [int64]$FilterExcludeOrganizationStatusID,

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

        $ResourceUri = '/organizations'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                           { $UriParameters['filter[id]']                               = $FilterID }
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

        if ($PSCmdlet.ParameterSetName -eq 'BulkDestroyPSA') {
            if ($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
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
