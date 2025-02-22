function Get-ITGlueBaseURI {
<#
    .SYNOPSIS
        Shows the ITGlue base URI

    .DESCRIPTION
        The Get-ITGlueBaseURI cmdlet shows the ITGlue base URI from
        the global variable

    .EXAMPLE
        Get-ITGlueBaseURI

        Shows the ITGlue base URI value defined in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueBaseURI.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding()]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleBaseURI) {
            $true   { $ITGlueModuleBaseURI }
            $false  { Write-Warning "The ITGlue base URI is not set. Run Add-ITGlueBaseURI to set the base URI." }
        }

    }

    end {}

}