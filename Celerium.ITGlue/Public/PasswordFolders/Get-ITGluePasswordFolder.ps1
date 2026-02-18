function Get-ITGluePasswordFolder {
<#
    .SYNOPSIS
        List or show password folders

    .DESCRIPTION
        The Get-ITGluePasswordFolder cmdlet returns list of password folders

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by password folder id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated-at',
        '-created_at', '-updated-at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a password folder by id

    .PARAMETER Include
        Include specified assets

        Allowed values:
        'user_resource_accesses', 'group_resource_accesses', 'authorized_users', 'ancestors'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGluePasswordFolder -OrganizationID 12345

        Returns the first 50 password folder results from your ITGlue account

    .EXAMPLE
        Get-ITGluePasswordFolder -OrganizationID 12345 -ID 8765309

        Returns the password folder with the defined id

    .EXAMPLE
        Get-ITGluePasswordFolder -OrganizationID 12345 -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for password folders
        for the defined organization in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Get-ITGluePasswordFolder.html

    .LINK
        https://api.itglue.com/developer/#password-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show', Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('created_at', 'updated-at','-created_at', '-updated-at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('user_resource_accesses', 'group_resource_accesses', 'authorized_users', 'ancestors')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName){
            'Index' {$ResourceUri = "/organizations/$OrganizationID/relationships/password_folders" }
            'Show'  {$ResourceUri = "/organizations/$OrganizationID/relationships/password_folders/$ID"}
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)                  { $UriParameters['filter[id]']                   = $FilterID }
            if ($Sort)                      { $UriParameters['sort']                         = $Sort }
            if ($PageNumber)                { $UriParameters['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $UriParameters['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {
            if($Include) { $UriParameters['include'] = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
