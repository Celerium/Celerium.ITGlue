function Get-ITGlueOperatingSystem {
<#
    .SYNOPSIS
        List or show all operating systems

    .DESCRIPTION
        The Get-ITGlueOperatingSystem cmdlet returns a list of supported operating systems
        or the details of a defined operating system

        This function can call the following endpoints:
            Index = /operating_systems

            Show =  /operating_systems/:id

    .PARAMETER FilterName
        Filter by operating system name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get an operating system by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOperatingSystem

        Returns the first 50 operating system results from your ITGlue account

    .EXAMPLE
        Get-ITGlueOperatingSystem -ID 8765309

        Returns the operating systems with the defined id

    .EXAMPLE
        Get-ITGlueOperatingSystem -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for operating systems
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OperatingSystems/Get-ITGlueOperatingSystem.html

    .LINK
        https://api.itglue.com/developer/#operating-systems-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

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
            'Index' { $ResourceUri = "/operating_systems" }
            'Show'  { $ResourceUri = "/operating_systems/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
