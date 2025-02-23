function Get-ITGlueCopilotSmartAssistDocument {
<#
    .SYNOPSIS
        Gets one or more documents found in the ITGlue Copilot Smart Assist

    .DESCRIPTION
        The Get-ITGlueCopilotSmartAssistDocument cmdlet gets one or more documents found
        in the ITGlue Copilot Smart Assist such as 'Documents not viewed in X amount of time',
        'Documents that were never viewed', 'Documents that are expired', and 'Duplicate documents'

        Present a list of 'Most Used' documents to facilitate best practices across organizations
        (when filter by type is not provided)

        This function can call the following endpoints:
            Index = /copilot_smart_assist/documents

    .PARAMETER FilterType
        Filter by type

        Allowed values:
        'stale', 'not_viewed', 'expired'

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueCopilotSmartAssistDocument

        Returns the first 50 documents from your ITGlue account

    .EXAMPLE
        Get-ITGlueCopilotSmartAssistDocument -OrganizationID 8765309

        Returns the first 50 documents from the defined organization

    .EXAMPLE
        Get-ITGlueCopilotSmartAssistDocument -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for documents
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Get-ITGlueCopilotSmartAssistDocument.html

    .LINK
        https://api.itglue.com/developer#copilot-smart-assist-documents
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet( 'stale', 'not_viewed', 'expired', 'duplicate' )]
        [string]$FilterType,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

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

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/copilot_smart_assist/documents" }
            $false  { $ResourceUri = "/copilot_smart_assist/documents" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterType)            { $query_params['filter[type]']             = $FilterID }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']  = $FilterOrganizationID}
            if ($PageNumber)            { $query_params['page[number]']             = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']               = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
