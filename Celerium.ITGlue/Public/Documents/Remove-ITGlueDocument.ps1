function Remove-ITGlueDocument {
<#
    .SYNOPSIS
        Deletes a new document

    .DESCRIPTION
        The Remove-ITGlueDocument cmdlet deletes a new document

    .PARAMETER OrganizationID
        The organization id to create the document in

    .PARAMETER ID
        Document ID

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueDocument -ID 8675309

        Deletes the defined document

    .EXAMPLE
        Remove-ITGlueDocument -OrganizationID 8675309 -Data $JsonBody

        Deletes the defined document in the specified organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Documents/Remove-ITGlueDocument.html

    .LINK
        https://api.itglue.com/developer/#documents
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/documents" }
            $false  { $ResourceUri = '/documents' }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Destroy') {
            $Data = @{
                type        = 'documents'
                attributes  = @{
                    id = $ID
                }
            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
