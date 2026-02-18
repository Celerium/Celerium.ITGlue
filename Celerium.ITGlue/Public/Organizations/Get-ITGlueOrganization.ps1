function Get-ITGlueOrganization {
<#
    .SYNOPSIS
        List or show all organizations

    .DESCRIPTION
        The Get-ITGlueOrganization cmdlet returns a list of organizations
        or details for a single organization in your account

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

    .PARAMETER FilterRange
        Filter organizations by range

    .PARAMETER FilterRangeMyGlueAccountID
        Filter MyGLue organization id range

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'updated_at', 'organization_status_name', 'organization_type_name',
        'created_at', 'short_name', 'my_glue_account_id', '-name', '-id', '-updated_at',
        '-organization_status_name', '-organization_type_name', '-created_at',
        '-short_name', '-my_glue_account_id'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get an organization by id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, rmm_companies

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        N/A

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOrganization

        Returns the first 50 organizations results from your ITGlue account

    .EXAMPLE
        Get-ITGlueOrganization -ID 8765309

        Returns the organization with the defined id

    .EXAMPLE
        Get-ITGlueOrganization -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for organizations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Get-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterRange,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterRangeMyGlueAccountID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [ValidateSet( 'name', 'id', 'updated_at', 'organization_status_name', 'organization_type_name', 'created_at', 'short_name', 'my_glue_account_id',
                '-name', '-id', '-updated_at', '-organization_status_name', '-organization_type_name', '-created_at', '-short_name', '-my_glue_account_id')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet( 'adapters_resources', 'attachments', 'rmm_companies' )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
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
            'Index*'    { $ResourceUri = "/organizations" }
            'Show'      { $ResourceUri = "/organizations/$ID" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Index*') {
            if ($FilterID)                          { $UriParameters['filter[id]']                               = $FilterID }
            if ($FilterName)                        { $UriParameters['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)          { $UriParameters['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)        { $UriParameters['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                   { $UriParameters['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                   { $UriParameters['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)             { $UriParameters['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)          { $UriParameters['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                     { $UriParameters['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                     { $UriParameters['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                   { $UriParameters['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                 { $UriParameters['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)   { $UriParameters['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID) { $UriParameters['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
            if ($FilterRange)                       { $UriParameters['filter[range]']                            = $FilterRange }
            if ($FilterRangeMyGlueAccountID)        { $UriParameters['filter[range][my_glue_account_id]']        = $FilterRangeMyGlueAccountID }
            if ($Sort)                              { $UriParameters['sort']                                     = $Sort }
            if ($PageNumber)                        { $UriParameters['page[number]']                             = $PageNumber }
            if ($PageSize)                          { $UriParameters['page[size]']                               = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'IndexPSA') {
            if ($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
        }

        #Shared Parameters
        if($Include) { $UriParameters['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
