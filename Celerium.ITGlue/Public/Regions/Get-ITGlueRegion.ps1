function Get-ITGlueRegion {
<#
    .SYNOPSIS
        List or show all regions

    .DESCRIPTION
        The Get-ITGlueRegion cmdlet returns a list of supported regions
        or the details of a single support region

        This function can call the following endpoints:
            Index = /regions
                    /countries/:id/relationships/regions

            Show =  /regions/:id
                    /countries/:country_id/relationships/regions/:id

    .PARAMETER CountryID
        Get regions by country id

    .PARAMETER FilterName
        Filter by region name

    .PARAMETER FilterISO
        Filter by region iso abbreviation

    .PARAMETER FilterCountryID
        Filter by country id

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
        Get a region by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueRegion

        Returns the first 50 region results from your ITGlue account

    .EXAMPLE
        Get-ITGlueRegion -ID 8765309

        Returns the region with the defined id

    .EXAMPLE
        Get-ITGlueRegion -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for regions
        in your ITGlue account

    .NOTES
        2024-09-26 - Using the "country_id" parameter does not appear to
        function at this time for either parameter set

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Regions/Get-ITGlueRegion.html

    .LINK
        https://api.itglue.com/developer/#regions-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$CountryID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterISO,

        [Parameter(ParameterSetName = 'Index')]
        [Int]$FilterCountryID,

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
            'Index' {
                if ($CountryID) {   $ResourceUri = "/countries/$CountryID/relationships/regions" }
                else{               $ResourceUri = "/regions" }
            }
            'Show'  {
                if ($CountryID) {   $ResourceUri = "/countries/$CountryID/relationships/regions/$ID" }
                else{               $ResourceUri = "/regions/$ID" }
            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)        { $query_params['filter[name]']         = $FilterName }
            if ($FilterISO)         { $query_params['filter[iso]']          = $FilterISO }
            if ($FilterCountryID)   { $query_params['filter[CountryID]']    = $FilterCountryID }
            if ($Sort)              { $query_params['sort']                 = $Sort }
            if ($PageNumber)        { $query_params['page[number]']         = $PageNumber }
            if ($PageSize)          { $query_params['page[size]']           = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
