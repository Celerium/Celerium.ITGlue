function New-ITGlueDocumentSection {
<#
    .SYNOPSIS
        Creates a new document section

    .DESCRIPTION
        The New-ITGlueDocumentSection cmdlet creates a new section in the specified document

        The resource_type attribute determines which type of section is created and
        which additional attributes are required

    .PARAMETER DocumentId
        The document id to create the section in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueDocumentSection -DocumentId 8675309 -Data $JsonBody

        Creates a new section in the defined document with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/New-ITGlueDocumentSection.html

    .LINK
        https://api.itglue.com/developer/#documentsections
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Create', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$DocumentId,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/documents/$DocumentId/relationships/sections"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
