function Remove-ITGlueBaseURI {
<#
    .SYNOPSIS
        Removes the ITGlue base URI global variable

    .DESCRIPTION
        The Remove-ITGlueBaseURI cmdlet removes the ITGlue base URI from
        the global variable

    .EXAMPLE
        Remove-ITGlueBaseURI

        Removes the ITGlue base URI value from the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleBaseURI) {

            $true   {
                if ($PSCmdlet.ShouldProcess('ITGlueModuleBaseURI')) {
                    Remove-Variable -Name "ITGlueModuleBaseURI" -Scope global -Force
                }
            }
            $false  { Write-Warning "The ITGlue base URI variable is not set. Nothing to remove" }

        }

    }

    end {}

}