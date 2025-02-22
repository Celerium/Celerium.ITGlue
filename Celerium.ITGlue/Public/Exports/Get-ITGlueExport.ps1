function Get-ITGlueExport {
<#
    .SYNOPSIS
        List or show all exports

    .DESCRIPTION
        The Get-ITGlueExport cmdlet returns a list of exports
        or the details of a single export in your account

        This function can call the following endpoints:
            Index = /exports

            Show =  /exports/:id

    .PARAMETER FilterID
        Filter by a export id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at',
        '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a export by id

    .PARAMETER Include
        Include additional information

        Allowed values:
        '.'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueExport

        Returns the first 50 exports from your ITGlue account

    .EXAMPLE
        Get-ITGlueExport -ID 8765309

        Returns the export with the defined id

    .EXAMPLE
        Get-ITGlueExport -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for exports
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Exports/Get-ITGlueExport.html

    .LINK
        https://api.itglue.com/developer/#exports-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('.')]
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
            'Index' { $ResourceUri = "/exports" }
            'Show'  { $ResourceUri = "/exports/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']   = $FilterID }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {
            if ($Include) { $query_params['include'] = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}