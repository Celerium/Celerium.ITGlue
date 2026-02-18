function Set-ITGlueDocumentSection {
<#
    .SYNOPSIS
        Updates an existing section

    .DESCRIPTION
        The Set-ITGlueDocumentSection cmdlet updates an existing section

        Only attributes specific to the section's resource_type can be updated.
        The resource_type itself cannot be changed

        A PATCH request does not require all attributes - only those you want to update.
        Any attributes you don't specify will remain unchanged

        IMPORTANT: The "rendered-content" attribute is READ-ONLY and automatically generated.
        Do not attempt to include it in your update requests - it will be ignored. When updating content,
        use only the "content" attribute with your HTML, and the "rendered-content" will be automatically
        regenerated with processed inline image URLs

        The resource_type attribute determines which type of section is created and
        which additional attributes are required

    .PARAMETER DocumentId
        The document id

    .PARAMETER Id
        The id of the section

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueDocumentSection -DocumentId 8675309 -Id 12345 -Data $JsonBody

        Creates a new section in the defined document with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Set-ITGlueDocumentSection.html

    .LINK
        https://api.itglue.com/developer/#documentsections
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$DocumentId,

        [Parameter(ParameterSetName = 'Update', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$Id,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        $Data
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
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
