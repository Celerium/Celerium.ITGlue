function Get-ITGlueLog {
<#
    .SYNOPSIS
        Get all activity logs of the account for the most recent 30 days

    .DESCRIPTION
        The Get-ITGlueLog cmdlet gets all activity logs of the account for
        the most recent 30 days

        IMPORTANT - This endpoint can ONLY get logs from the past 30 days!

        This endpoint is limited to 5 pages of results. If more results are desired,
        setting a larger page [size] will increase the number of results per page

        To iterate over even more results, use filter [created_at] (with created_at Sort)
        to fetch a subset of results based on timestamp, then use the last timestamp
        in the last page the start date in the filter for the next request

    .PARAMETER FilterCreatedAt
        Filter logs by a UTC start & end date

        Use `*` for unspecified start_date` or `end_date

        The specified string must be a date range and comma-separated as start_date, end_date

        Example:
        2024-09-23, 2024-09-27

        Date ranges longer than a week may be disallowed for performance reasons

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at','-created_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

        This endpoint is limited to 5 pages of results

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueLog

        Pulls the first 50 activity logs from the last 30 days with data
        being Sorted newest to oldest

    .EXAMPLE
        Get-ITGlueLog -sort -created_at

        Pulls the first 50 activity logs from the last 30 days with data
        being Sorted oldest to newest

    .EXAMPLE
        Get-ITGlueLog -PageNumber 2

        Pulls the first 50 activity logs starting from page 2 from the last 30 days
        with data being Sorted newest to oldest

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Logs/Get-ITGlueLog.html

    .LINK
        https://api.itglue.com/developer/#logs
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet( 'created_at','-created_at' )]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

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

        $ResourceUri = '/logs'

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterCreatedAt)   { $UriParameters['filter[created_at]']   = $FilterCreatedAt }
            if ($Sort)              { $UriParameters['sort']                 = $Sort }
            if ($PageNumber)        { $UriParameters['page[number]']         = $PageNumber }
            if ($PageSize)          { $UriParameters['page[size]']           = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
