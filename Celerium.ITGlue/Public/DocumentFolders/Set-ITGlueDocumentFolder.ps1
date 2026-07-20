function Set-ITGlueDocumentFolder {
<#
    .SYNOPSIS
        Updates one or more document folders

    .DESCRIPTION
        The Set-ITGlueDocumentFolder cmdlet updates one or
        more existing document folders

        Any attributes you don't specify will remain unchanged

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER ID
        The document folder id to update

    .PARAMETER NewName
        The new name of the document folder

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueDocumentFolder -ID 8675309 -Data $JsonBody

        Updates the defined document folder with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Set-ITGlueDocumentFolder.html

    .LINK
        https://api.itglue.com/developer/#document-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [ValidateNotNullOrEmpty()]
        [string]$NewName,

        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        { $ResourceUri = "/organizations/$OrganizationID/relationships/document_folders/$ID" }
            'BulkUpdate'    { $ResourceUri = "/document_folders" }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Update') {
            $Data = @{
                type        = 'document-folders'
                attributes  = @{
                    name = $NewName
                }
            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }


    }

    end {}

}
