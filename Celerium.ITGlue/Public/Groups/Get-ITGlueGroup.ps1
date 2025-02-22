function Get-ITGlueGroup {
<#
    .SYNOPSIS
        List or show all groups

    .DESCRIPTION
        The Get-ITGlueGroup cmdlet returns a list of groups or the
        details of a single group in your account

        This function can call the following endpoints:
            Index = /groups

            Show =  /groups/:id

    .PARAMETER FilterName
        Filter by a group name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at',
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a group by id

    .PARAMETER Include
        Include other items with groups

        Allowed values:
        'users'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueGroup

        Returns the first 50 group results from your ITGlue account

    .EXAMPLE
        Get-ITGlueGroup -ID 8765309

        Returns the group with the defined id

    .EXAMPLE
        Get-ITGlueGroup -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for groups
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Groups/Get-ITGlueGroup.html

    .LINK
        https://api.itglue.com/developer/#groups-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('users')]
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

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/groups" }
            'Show'  { $ResourceUri = "/groups/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #Shared Parameters
        if ($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
