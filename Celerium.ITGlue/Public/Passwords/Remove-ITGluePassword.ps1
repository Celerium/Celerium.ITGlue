function Remove-ITGluePassword {
<#
    .SYNOPSIS
        Deletes one or more passwords

    .DESCRIPTION
        The Remove-ITGluePassword cmdlet destroys one or more
        passwords specified by ID

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
        https://api.itglue.com/developer/#passwords
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$FilterPasswordCategoryID,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [string]$FilterUrl,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [string]$FilterCachedResourceName,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

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

        switch ($PSCmdlet.ParameterSetName) {
            'BulkDestroy'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords/$ID" }
                    $false  { $ResourceUri = "/passwords" }
                }

            }
            'Destroy'       { $ResourceUri = "/passwords/$ID" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'BulkDestroy') {
            if ($FilterID)                  { $UriParameters['filter[id]']                   = $FilterID }
            if ($FilterName)                { $UriParameters['filter[name]']                 = $FilterName }
            if ($FilterOrganizationID)      { $UriParameters['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPasswordCategoryID)  { $UriParameters['filter[password_category_id]'] = $FilterPasswordCategoryID }
            if ($FilterUrl)                 { $UriParameters['filter[url]']                  = $FilterUrl }
            if ($FilterCachedResourceName)  { $UriParameters['filter[cached_resource_name]'] = $FilterCachedResourceName }
            if ($FilterArchived)            { $UriParameters['filter[archived]']             = $FilterArchived }
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
