function Remove-ITGlueDocumentImage {
<#
    .SYNOPSIS
        Deletes the specified document image and all its size variants

    .DESCRIPTION
        The Remove-ITGlueDocumentImage cmdlet deletes the specified document image
        and all its size variants

        Deleting an image that is referenced in document content (as an inline image) will not
        automatically remove the <img> tags from the content
        The inline image validation will remove broken image references on the next content save

    .PARAMETER ID
        Image id

    .EXAMPLE
        Remove-ITGlueDocumentImage -ID 12345

        Deletes the image with the specified ID

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/Remove-ITGlueDocumentImage.html

    .LINK
        https://api.itglue.com/developer/#documentimages
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$Id
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/document_images/$Id"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri

    }

    end {}

}
