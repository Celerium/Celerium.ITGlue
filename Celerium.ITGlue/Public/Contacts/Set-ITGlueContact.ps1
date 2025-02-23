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

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [switch]$FilterImportant,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA', Mandatory = $true)]
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
            'Bulk_Update'   { $ResourceUri = "/contacts" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like "Bulk_Update_*") {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterFirstName)       { $query_params['filter[first_name]']       = $FilterFirstName }
            if ($FilterLastName)        { $query_params['filter[last_name]']        = $FilterLastName }
            if ($FilterTitle)           { $query_params['filter[title]']            = $FilterTitle }
            if ($FilterContactTypeID)   { $query_params['filter[contact_type_id]']  = $FilterContactTypeID }

            if ($FilterImportant -eq $true)         { $query_params['filter[important]'] = '1' }
            elseif ($FilterImportant -eq $false)    { $query_params['filter[important]'] = '0'}

            if ($FilterPrimaryEmail)        { $query_params['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update_ByFilter_PSA') {
            if($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
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
