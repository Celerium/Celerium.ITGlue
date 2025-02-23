function Set-ITGlueCopilotSmartAssistDocument {
<#
    .SYNOPSIS
        Updates one or more documents found in the ITGlue Copilot Smart Assist

    .DESCRIPTION
        The Set-ITGlueCopilotSmartAssistDocument cmdlet updates (archives) one or more documents
        found in the ITGlue Copilot Smart Assist

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Bulk_Update =   /copilot_smart_assist/documents
                            /organizations/:organization_id/copilot_smart_assist/documents

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER FilterType
        Filter by type

        Allowed values:
        'stale', 'not_viewed', 'expired'

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueCopilotSmartAssistDocument -Data $JsonBody

        Updates the defined document with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Set-ITGlueCopilotSmartAssistDocument.html

    .LINK
        https://api.itglue.com/developer#copilot-smart-assist-bulk-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Update')]
        [ValidateSet( 'stale', 'not_viewed', 'expired', 'duplicate' )]
        [string]$FilterType,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data

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

        if ($PSCmdlet.ParameterSetName -eq "Bulk_Update") {
            if ($FilterType)            { $query_params['filter[type]']             = $FilterID }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']  = $FilterOrganizationID}
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
