function Publish-ITGlueDocument {
<#
    .SYNOPSIS
        Publishes a document

    .DESCRIPTION
        The Publish-ITGlueDocument cmdlet publishes a document

    .PARAMETER OrganizationID
        The organization id to create the document in

    .PARAMETER ID
        Document ID

    .EXAMPLE
        Publish-ITGlueDocument -ID 8675309

        Publishes the defined document

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Documents/Publish-ITGlueDocument.html

    .LINK
        https://api.itglue.com/developer/#documents
#>

    [CmdletBinding(DefaultParameterSetName = 'Publish', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Publish')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Publish', Mandatory = $true)]
        [int64]$ID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/documents/$ID/publish" }
            $false  { $ResourceUri = "/documents/$ID/publish" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri
        }

    }

    end {}

}
