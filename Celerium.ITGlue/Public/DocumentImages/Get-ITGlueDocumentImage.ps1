function Get-ITGlueDocumentImage {
<#
    .SYNOPSIS
        Returns details of a specific document image including URLs
        for all size variants

    .DESCRIPTION
        The Get-ITGlueDocumentImage cmdlet returns details of a specific
        document image including URLs for all size variants

    .PARAMETER ID
        Image id

    .EXAMPLE
        Get-ITGlueDocumentImage -Id 8765309

        Returns details of a specific document image including URLs for all size variants

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentImages/Get-ITGlueDocumentImage.html

    .LINK
        https://api.itglue.com/developer/#documentimages
#>

    [CmdletBinding(DefaultParameterSetName = 'Show')]
    Param (
        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
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

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri

    }

    end {}

}
