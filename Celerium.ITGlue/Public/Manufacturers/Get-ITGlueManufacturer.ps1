function Get-ITGlueManufacturer {
<#
    .SYNOPSIS
        List or show all manufacturers

    .DESCRIPTION
        The Get-ITGlueManufacturer cmdlet returns a manufacturer name
        or a list of manufacturers in your account

        This function can call the following endpoints:
            Index = /manufacturers

            Show =  /manufacturers/:id

    .PARAMETER FilterName
        Filter by a manufacturers name

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
        Get a manufacturer by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueManufacturer

        Returns the first 50 manufacturer results from your ITGlue account

    .EXAMPLE
        Get-ITGlueManufacturer -ID 8765309

        Returns the manufacturer with the defined id

    .EXAMPLE
        Get-ITGlueManufacturer -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for manufacturers
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Get-ITGlueManufacturer.html

    .LINK
        https://api.itglue.com/developer/#manufacturers-index
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
            'Index' { $ResourceUri = "/manufacturers" }
            'Show'  { $ResourceUri = "/manufacturers/$ID" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $UriParameters['filter[name]'] = $FilterName }
            if ($Sort)          { $UriParameters['sort']         = $Sort }
            if ($PageNumber)    { $UriParameters['page[number]'] = $PageNumber }
            if ($PageSize)      { $UriParameters['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
