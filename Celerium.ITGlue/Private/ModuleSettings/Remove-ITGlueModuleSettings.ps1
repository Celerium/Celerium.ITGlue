function Remove-ITGlueModuleSettings {
<#
    .SYNOPSIS
        Removes the stored ITGlue configuration folder

    .DESCRIPTION
        The Remove-ITGlueModuleSettings cmdlet removes the ITGlue folder and its files
        This cmdlet also has the option to remove sensitive ITGlue variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER ITGlueConfigPath
        Define the location of the ITGlue configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER AndVariables
        Define if sensitive ITGlue variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-ITGlueModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the ITGlue configuration folder is:
            $env:USERPROFILE\Celerium.ITGlue

    .EXAMPLE
        Remove-ITGlueModuleSettings -ITGlueConfigPath C:\Celerium.ITGlue -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive ITGlue variables exist then they are removed as well

        The location of the ITGlue configuration folder in this example is:
            C:\Celerium.ITGlue

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy',SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter()]
        [string]$ITGlueConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) ),

        [Parameter()]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $ITGlueConfigPath)  {

            Remove-Item -Path $ITGlueConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-ITGlueApiKey
                Remove-ITGlueBaseUri
            }

            if ($WhatIfPreference -eq $false) {

                if (!(Test-Path $ITGlueConfigPath)) {
                    Write-Output "The Celerium.ITGlue configuration folder has been removed successfully from [ $ITGlueConfigPath ]"
                }
                else {
                    Write-Error "The Celerium.ITGlue configuration folder could not be removed from [ $ITGlueConfigPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $ITGlueConfigPath ]"
        }

    }

    end {}

}