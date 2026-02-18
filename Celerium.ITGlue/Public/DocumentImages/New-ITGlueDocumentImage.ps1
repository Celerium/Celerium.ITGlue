function New-ITGlueDocumentImage {
<#
    .SYNOPSIS
        Creates a new document image

    .DESCRIPTION
        The New-ITGlueDocumentImage cmdlet creates a new document image

        Images are placed using the 'target' attribute which specifies whether the
        image is for a gallery or inline in a document

        The image must be uploaded as Base64-encoded content with a file name.

        Required attributes:
        target:             { type: 'gallery'|'document', id: integer }
        image.content:      Base64-encoded image data
        image.file-name:    Original filename with extension

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueDocumentImage -Data $JsonBody

        Creates a new image with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/New-ITGlueDocumentImage.html

    .LINK
        https://api.itglue.com/developer/#documentimages
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Create', ValueFromPipeline = $true , Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/document_images"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data

    }

    end {}

}
