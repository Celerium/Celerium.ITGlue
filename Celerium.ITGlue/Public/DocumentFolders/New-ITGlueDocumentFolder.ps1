function New-ITGlueDocumentFolder {
<#
    .SYNOPSIS
        Creates a new document folder

    .DESCRIPTION
        The New-ITGlueDocumentFolder cmdlet creates a new document

    .PARAMETER OrganizationID
        The organization id to create the flexible asset in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueDocument -OrganizationID 8675309 -Data $JsonBody

        Creates a new flexible asset in the defined organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/New-ITGlueDocumentFolder.html

    .LINK
        https://api.itglue.com/developer/#document-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Create')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/organizations/$OrganizationID/relationships/document_folders"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
