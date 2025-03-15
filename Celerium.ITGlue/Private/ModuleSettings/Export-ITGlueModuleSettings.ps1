function Export-ITGlueModuleSettings {
<#
    .SYNOPSIS
        Exports the ITGlue BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-ITGlueModuleSettings cmdlet exports the ITGlue BaseURI, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER ITGlueConfigPath
        Define the location to store the ITGlue configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER ITGlueConfigFile
        Define the name of the ITGlue configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-ITGlueModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's ITGlue configuration file located at:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Export-ITGlueModuleSettings -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's ITGlue configuration file located at:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Export-ITGlueModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$ITGlueConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) ),

        [Parameter()]
        [string]$ITGlueConfigFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $ITGlueConfig = Join-Path -Path $ITGlueConfigPath -ChildPath $ITGlueConfigFile

        # Confirm variables exist and are not null before exporting
        if ($ITGlueModuleBaseURI -and $ITGlueModuleApiKey -and $ITGlueModuleJSONConversionDepth) {
            $SecureString = $ITGlueModuleApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $ITGlueConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $ITGlueConfigPath -ItemType Directory -Force
            }
@"
    @{
        ITGlueModuleBaseURI             = '$ITGlueModuleBaseURI'
        ITGlueModuleApiKey              = '$SecureString'
        ITGlueModuleJSONConversionDepth = '$ITGlueModuleJSONConversionDepth'
    }
"@ | Out-File -FilePath $ITGlueConfig -Force
        }
        else {
            Write-Error "Failed to export ITGlue Module settings to [ $ITGlueConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}