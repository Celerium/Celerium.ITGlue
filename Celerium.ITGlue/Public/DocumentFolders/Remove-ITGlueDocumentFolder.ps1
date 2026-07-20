function Remove-ITGlueDocumentFolder {
<#
    .SYNOPSIS
        Deletes a document folder

    .DESCRIPTION
        The Remove-ITGlueDocumentFolder cmdlet
        deletes a document folder

    .PARAMETER OrganizationID
        The organization id to create the document in

    .PARAMETER ID
        Document ID

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueDocumentFolder -ID 8675309

        Deletes the defined document folder

    .EXAMPLE
        Remove-ITGlueDocumentFolder -OrganizationID 8675309 -Data $JsonBody

        Deletes the defined document folder in the specified organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Remove-ITGlueDocumentFolder.html

    .LINK
        https://api.itglue.com/developer/#document-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
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

        $ResourceUri = "/organizations/$OrganizationID/relationships/document_folders"

        if ($PSCmdlet.ParameterSetName -eq 'Destroy') {
            $Data = @{
                type        = 'document-folders'
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
