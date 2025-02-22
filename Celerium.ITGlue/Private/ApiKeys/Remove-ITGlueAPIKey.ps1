function Remove-ITGlueAPIKey {
<#
    .SYNOPSIS
        Removes the ITGlue API key

    .DESCRIPTION
        The Remove-ITGlueAPIKey cmdlet removes the ITGlue API key from
        global variable

    .EXAMPLE
        Remove-ITGlueAPIKey

        Removes the ITGlue API key global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueAPIKey.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleAPIKey) {

            $true   {
                if ($PSCmdlet.ShouldProcess('ITGlueModuleAPIKey')) {
                Remove-Variable -Name "ITGlueModuleAPIKey" -Scope global -Force }
            }

            $false  { Write-Warning "The ITGlue API [ secret ] key is not set. Nothing to remove" }

        }

    }

    end {}

}