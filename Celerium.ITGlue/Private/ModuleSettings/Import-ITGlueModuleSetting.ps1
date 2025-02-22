function Import-ITGlueModuleSetting {
<#
    .SYNOPSIS
        Imports the ITGlue BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-ITGlueModuleSetting cmdlet imports the ITGlue BaseURI, API, & JSON configuration
        information stored in the ITGlue configuration file to the users current session

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER ITGlueConfigPath
        Define the location to store the ITGlue configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER ITGlueConfigFile
        Define the name of the ITGlue configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-ITGlueModuleSetting

        Validates that the configuration file created with the Export-ITGlueModuleSetting cmdlet exists
        then imports the stored data into the current users session

        The default location of the ITGlue configuration file is:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Import-ITGlueModuleSetting -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1

        Validates that the configuration file created with the Export-ITGlueModuleSetting cmdlet exists
        then imports the stored data into the current users session

        The location of the ITGlue configuration file in this example is:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Import-ITGlueModuleSetting.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$ITGlueConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) ),

        [Parameter()]
        [string]$ITGlueConfigFile = 'config.psd1'
    )

    begin {
        $ITGlueConfig = Join-Path -Path $ITGlueConfigPath -ChildPath $ITGlueConfigFile
    }

    process {

        if (Test-Path $ITGlueConfig) {
            $tmp_config = Import-LocalizedData -BaseDirectory $ITGlueConfigPath -FileName $ITGlueConfigFile

            # Send to function to strip potentially superfluous slash (/)
            Add-ITGlueBaseURI $tmp_config.ITGlueModuleBaseURI

            $tmp_config.ITGlueModuleAPIKey = ConvertTo-SecureString $tmp_config.ITGlueModuleAPIKey

            Set-Variable -Name "ITGlueModuleAPIKey" -Value $tmp_config.ITGlueModuleAPIKey -Option ReadOnly -Scope global -Force

            Set-Variable -Name "ITGlueModuleJSONConversionDepth" -Value $tmp_config.ITGlueModuleJSONConversionDepth -Scope global -Force

            Write-Verbose "Celerium.ITGlue Module configuration loaded successfully from [ $ITGlueConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $ITGlueConfig ] run Add-ITGlueAPIKey to get started."

            Add-ITGlueBaseURI

            Set-Variable -Name "ITGlueModuleBaseURI" -Value $(Get-ITGlueBaseURI) -Option ReadOnly -Scope global -Force
            Set-Variable -Name "ITGlueModuleJSONConversionDepth" -Value 100 -Scope global -Force
        }

    }

    end {}

}