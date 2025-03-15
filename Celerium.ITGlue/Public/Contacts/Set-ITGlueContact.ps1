function Set-ITGlueContact {
<#
    .SYNOPSIS
        Updates one or more contacts

    .DESCRIPTION
        The Set-ITGlueContact cmdlet updates the details of one
        or more specified contacts

        Returns 422 Bad Request error if trying to update an externally synced record

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update = /contacts/:id
                    /organizations/:organization_id/relationships/contacts/:id

            Bulk_Update =  /contacts

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        Define a contact id

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
        Set-ITGlueContact -id 8675309 -Data $JsonBody

        Updates the defined contact with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Set-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-update
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [switch]$FilterImportant,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'BulkUpdateByFilter')]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdateByFilter', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdateByFilterPSA', Mandatory = $true)]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts/$ID" }
                    $false  { $ResourceUri = "/contacts/$ID" }
                }

            }
            'BulkUpdate'   { $ResourceUri = "/contacts" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like "Bulk_Update_*") {
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

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdateByFilterPSA') {
            if($FilterPsaID) { $UriParameters['filter[psa_id]'] = $FilterPsaID }
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
