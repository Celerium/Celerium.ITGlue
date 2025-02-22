function Remove-ITGluePassword {
<#
    .SYNOPSIS
        Deletes one or more passwords

    .DESCRIPTION
        The Remove-ITGluePassword cmdlet destroys one or more
        passwords specified by ID

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        Delete a password by id

    .PARAMETER FilterID
        Filter by password id

    .PARAMETER FilterName
        Filter by password name

    .PARAMETER FilterOrganizationID
        Filter for passwords by organization id

    .PARAMETER FilterPasswordCategoryID
        Filter by passwords category id

    .PARAMETER FilterUrl
        Filter by password url

    .PARAMETER FilterCachedResourceName
        Filter by a passwords cached resource name

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGluePassword -id 8675309

        Deletes the defined password

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Passwords/Remove-ITGluePassword.html

    .LINK
        https://api.itglue.com/developer/#passwords-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterPasswordCategoryID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterUrl,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterCachedResourceName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
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
            'Bulk_Destroy'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords/$ID" }
                    $false  { $ResourceUri = "/passwords" }
                }

            }
            'Destroy'       { $ResourceUri = "/passwords/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPasswordCategoryID)  { $query_params['filter[password_category_id]'] = $FilterPasswordCategoryID }
            if ($FilterUrl)                 { $query_params['filter[url]']                  = $FilterUrl }
            if ($FilterCachedResourceName)  { $query_params['filter[cached_resource_name]'] = $FilterCachedResourceName }
            if ($FilterArchived)            { $query_params['filter[archived]']             = $FilterArchived }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
