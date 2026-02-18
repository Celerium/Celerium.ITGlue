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
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleApiKey) {

            $true   {
                if ($PSCmdlet.ShouldProcess('ITGlueModuleApiKey')) {
                    Remove-Variable -Name "ITGlueModuleApiKey" -Scope Global -Force
                }
            }

            $false  { Write-Warning "The ITGlue API [ secret ] key is not set. Nothing to remove" }

        }

    }

    end {}

}