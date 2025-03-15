function Remove-ITGlueCopilotSmartAssistDocument {
<#
    .SYNOPSIS
        Deletes one or more documents found in the ITGlue Copilot Smart Assist

    .DESCRIPTION
        The Remove-ITGlueCopilotSmartAssistDocument cmdlet deletes one or more documents
        found in the ITGlue Copilot Smart Assist

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Bulk_Destroy =  /copilot_smart_assist/documents
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
        Remove-ITGlueCopilotSmartAssistDocument -Data $JsonBody

        Deletes the defined document with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/CopilotSmartAssist/Remove-ITGlueCopilotSmartAssistDocument.html

    .LINK
        https://api.itglue.com/developer#copilot-smart-assist-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [ValidateSet( 'stale', 'not_viewed', 'expired', 'duplicate' )]
        [string]$FilterType,

        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
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

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq "Bulk_Destroy") {
            if ($FilterType)            { $UriParameters['filter[type]']             = $FilterID }
            if ($FilterOrganizationID)  { $UriParameters['filter[organization_id]']  = $FilterOrganizationID}
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -UriFilter $UriParameters -Data $Data
        }

    }

    end {}

}
