function Remove-ITGlueDocumentSection {
<#
    .SYNOPSIS
        Deletes the specified section and its associated polymorphic resource

    .DESCRIPTION
        The Remove-ITGlueDocumentSection cmdlet deletes the specified section
        and its associated polymorphic resource

        Deleting a Gallery or Step section will also delete all associated images

    .PARAMETER DocumentId
        The document id

    .PARAMETER Id
        The id of the section

    .EXAMPLE
        Remove-ITGlueDocumentSection -DocumentId 8675309 -Id 12345 -Data $JsonBody

        Deletes the specified section in the defined document

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Remove-ITGlueDocumentSection.html

    .LINK
        https://api.itglue.com/developer/#documentsections
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$DocumentId,

        [Parameter(ParameterSetName = 'Destroy', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$Id
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/documents/$DocumentId/relationships/sections/$Id"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
