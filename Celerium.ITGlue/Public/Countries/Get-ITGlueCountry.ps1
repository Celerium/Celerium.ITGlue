function Get-ITGlueCountry {
<#
    .SYNOPSIS
        Returns a list of supported countries

    .DESCRIPTION
        The Get-ITGlueCountry cmdlet returns a list of supported countries
        as well or details of one of the supported countries

        This function can call the following endpoints:
            Index = /countries

            Show =  /countries/:id

    .PARAMETER FilterName
        Filter by country name

    .PARAMETER FilterISO
        Filter by country iso abbreviation

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
        Get a country by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueCountry

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueCountry -ID 8765309

        Returns the country details with the defined id

    .EXAMPLE
        Get-ITGlueCountry -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for countries
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Countries/Get-ITGlueCountry.html

    .LINK
        https://api.itglue.com/developer/#countries-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterISO,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
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
            'Index' { $ResourceUri = "/countries" }
            'Show'  { $ResourceUri = "/countries/$ID" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $UriParameters['filter[name]'] = $FilterName }
            if ($FilterISO)     { $UriParameters['filter[iso]']  = $FilterISO }
            if ($Sort)          { $UriParameters['sort']         = $Sort }
            if ($PageNumber)    { $UriParameters["page[number]"] = $PageNumber }
            if ($PageSize)      { $UriParameters["page[size]"]   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
