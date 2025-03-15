function Remove-ITGlueContact {
<#
    .SYNOPSIS
        Deletes one or more contacts

    .DESCRIPTION
        The Remove-ITGlueContact cmdlet deletes one or more specified contacts

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

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

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueContact -Data $JsonBody

        Deletes contacts with the defined in structured
        JSON object

    .EXAMPLE
        Remove-ITGlueContact -FilterID 8675309

        Deletes contacts with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Remove-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [switch]$FilterImportant,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkDestroyByFilter')]
        [Parameter(ParameterSetName = 'BulkDestroyByFilterPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
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
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts" }
            $false  { $ResourceUri = "/contacts" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like "Bulk_Destroy_*") {
            if ($FilterID)              { $UriParameters['filter[id]']               = $FilterID }
            if ($FilterFirstName)       { $UriParameters['filter[first_name]']       = $FilterFirstName }
            if ($FilterLastName)        { $UriParameters['filter[last_name]']        = $FilterLastName }
            if ($FilterTitle)           { $UriParameters['filter[title]']            = $FilterTitle }
            if ($FilterContactTypeID)   { $UriParameters['filter[contact_type_id]']  = $FilterContactTypeID }

            if ($FilterImportant -eq $true)         { $UriParameters['filter[important]'] = '1' }
            elseif ($FilterImportant -eq $false)    { $UriParameters['filter[important]'] = '0'}

            if ($FilterPrimaryEmail)        { $UriParameters['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $UriParameters['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $UriParameters['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'BulkDestroyByFilterPSA') {
            if($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
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
