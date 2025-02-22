function Get-ITGlueDomain {
<#
    .SYNOPSIS
        List or show all domains

    .DESCRIPTION
        The Get-ITGlueDomain cmdlet list or show all domains in
        your account or from a specified organization

        This function can call the following endpoints:
            Index = /domains
                    /organizations/:organization_id/relationships/domains

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER FilterID
        The domain id to filter for

    .PARAMETER FilterOrganizationID
        The organization id to filter for

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at'
        '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values:
        'passwords', 'attachments', 'user_resource_accesses', 'group_resource_accesses'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueDomain

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueDomain -OrganizationID 12345

        Returns the domains from the defined organization id

    .EXAMPLE
        Get-ITGlueDomain -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for domains
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Domains/Get-ITGlueDomain.html

    .LINK
        https://api.itglue.com/developer/#domains-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('passwords', 'attachments', 'user_resource_accesses', 'group_resource_accesses')]
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

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/domains" }
            $false  { $ResourceUri = "/domains" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']  = $FilterOrganizationID }
            if ($Sort)                  { $query_params['sort']                     = $Sort }
            if ($PageNumber)            { $query_params['page[number]']             = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']               = $PageSize}
            if ($Include)               { $query_params['include']                  = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
