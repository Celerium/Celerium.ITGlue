function Get-ITGlueContact {
<#
    .SYNOPSIS
        List or show all contacts

    .DESCRIPTION
        The Get-ITGlueContact cmdlet lists all or a single contact(s)
        from your account or a defined organization

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by contact id

    .PARAMETER FilterFirstName
        Filter by contact first name

    .PARAMETER FilterLastName
        Filter by contact last name

    .PARAMETER FilterTitle
        Filter by contact title

    .PARAMETER FilterContactTypeID
        Filter by contact type id

    .PARAMETER FilterImportant
        Filter by if contact is important

        A users important field in ITGlue can sometimes
        be null which will cause this parameter to return
        incomplete information

    .PARAMETER FilterPrimaryEmail
        Filter by contact primary email address

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a PSA id

        This must be accompanied by the filter for FilterPsaIntegrationType

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'first_name', 'last_name', 'id', 'created_at', 'updated_at',
        '-first_name', '-last_name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Define a contact id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, distinct_remote_contacts, group_resource_accesses,
        location, passwords, resource_fields, tickets, user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        recent_versions, related_items, authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueContact

        Returns the first 50 contacts from your ITGlue account

    .EXAMPLE
        Get-ITGlueContact -OrganizationID 8765309

        Returns the first 50 contacts from the defined organization

    .EXAMPLE
        Get-ITGlueContact -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for contacts
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Get-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [ValidateSet('true', 'false')]
        [string]$FilterImportant,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'IndexPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [ValidateSet(   'first_name', 'last_name', 'id', 'created_at', 'updated_at',
                        '-first_name', '-last_name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'IndexPSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources','attachments', 'authorized_users', 'distinct_remote_contacts',
                        'group_resource_accesses', 'location', 'passwords', 'recent_versions',
                        'related_items', 'resource_fields', 'tickets','user_resource_accesses')]
        $Include,

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

        if ($PSCmdlet.ParameterSetName -eq 'Index' -or $PSCmdlet.ParameterSetName -eq 'IndexPSA') {

            switch ([bool]$OrganizationID) {
                $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts" }
                $false  { $ResourceUri = "/contacts" }
            }

        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {

            switch ([bool]$OrganizationID) {
                $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts/$ID" }
                $false  { $ResourceUri = "/contacts/$ID" }
            }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if (($PSCmdlet.ParameterSetName -eq 'Index') -or ($PSCmdlet.ParameterSetName -eq 'IndexPSA')) {
            if ($FilterID)                  { $UriParameters['filter[id]']                   = $FilterID }
            if ($FilterFirstName)           { $UriParameters['filter[first_name]']           = $FilterFirstName }
            if ($FilterLastName)            { $UriParameters['filter[last_name]']            = $FilterLastName }
            if ($FilterTitle)               { $UriParameters['filter[title]']                = $FilterTitle }
            if ($FilterContactTypeID)       { $UriParameters['filter[contact_type_id]']      = $FilterContactTypeID }
            if ($FilterImportant)           { $UriParameters['filter[important]']            = $FilterImportant }
            if ($FilterPrimaryEmail)        { $UriParameters['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $UriParameters['filter[organization_id]']      = $FilterOrganizationID}
            if ($FilterPsaIntegrationType)  { $UriParameters['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
            if ($Sort)                      { $UriParameters['sort']                         = $Sort }
            if ($PageNumber)                { $UriParameters['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $UriParameters['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'IndexPSA') {
            if($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
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
