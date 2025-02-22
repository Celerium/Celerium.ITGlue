function Get-ITGlueExpiration {
<#
    .SYNOPSIS
        List or show all expirations

    .DESCRIPTION
        The Get-ITGlueExpiration cmdlet returns a list of expirations
        for all organizations or for a specified organization

        This function can call the following endpoints:
            Index = /expirations
                    /organizations/:organization_id/relationships/expirations

            Show =  /expirations/:id
                    /organizations/:organization_id/relationships/expirations/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by expiration id

    .PARAMETER FilterResourceID
        Filter by a resource id

    .PARAMETER FilterResourceName
        Filter by a resource name

    .PARAMETER FilterResourceTypeName
        Filter by a resource type name

    .PARAMETER FilterDescription
        Filter expiration description

    .PARAMETER FilterExpirationDate
        Filter expiration date

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterRange
        Filter by expiration range

        To filter on a specific range, supply two comma-separated values
        Example:
            "2, 10" is filtering for all that are greater than or equal to 2
            and less than or equal to 10

        Or, an asterisk ( * ) can filter on values either greater than or equal to
            Example:
                "2, *", or less than or equal to ("*, 10")

    .PARAMETER FilterRangeExpirationDate
        Filter by expiration date range

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'id', 'organization_id', 'expiration_date', 'created_at', 'updated_at',
        '-id', '-organization_id', '-expiration_date', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        A valid expiration ID

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueExpiration

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueExpiration -ID 8765309

        Returns the expiration with the defined id

    .EXAMPLE
        Get-ITGlueExpiration -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for expirations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Expirations/Get-ITGlueExpiration.html

    .LINK
        https://api.itglue.com/developer/#expirations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterResourceID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceTypeName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterDescription,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterExpirationDate,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterRange,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterRangeExpirationDate,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'id', 'organization_id', 'expiration_date', 'created_at', 'updated_at',
                        '-id', '-organization_id', '-expiration_date', '-created_at', '-updated_at')]
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

                if ($OrganizationID) {
                    $ResourceUri = "/organizations/$OrganizationID/relationships/expirations"
                }
                else{$ResourceUri = "/expirations"}

            }
            'Show'  {

                if ($OrganizationID) {
                    $ResourceUri = "/organizations/$OrganizationID/relationships/expirations/$ID"
                }
                else{$ResourceUri = "/expirations/$ID"}

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $query_params['filter[id]']                   = $FilterID }
            if ($FilterResourceID)      { $query_params['filter[resource_id]']          = $FilterResourceID }
            if ($FilterResourceName)    { $query_params['filter[resource_name]']        = $FilterResourceName }
            if ($FilterResourceTypeName) { $query_params['filter[resource_type_name]']   = $FilterResourceTypeName }
            if ($FilterDescription)     { $query_params['filter[description]']          = $FilterDescription }
            if ($FilterExpirationDate)  { $query_params['filter[expiration_date]']      = $FilterExpirationDate }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterRange)           { $query_params['filter[range]']                = $FilterRange }
            if ($Sort)                  { $query_params['sort']                         = $Sort }
            if ($PageNumber)            { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']                   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
