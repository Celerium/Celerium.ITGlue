function Get-ITGlueModuleSettings {
<#
    .SYNOPSIS
        Gets the saved ITGlue configuration settings

    .DESCRIPTION
        The Get-ITGlueModuleSettings cmdlet gets the saved ITGlue configuration settings
        from the local system

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

    .PARAMETER OpenConfigFile
        Opens the ITGlue configuration file

    .EXAMPLE
        Get-ITGlueModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-ITGlueModuleSettings

        The default location of the ITGlue configuration file is:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Get-ITGlueModuleSettings -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the ITGlue configuration file in this example is:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter()]
        [string]$ITGlueConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) ),

        [Parameter()]
        [string]$ITGlueConfigFile = 'config.psd1',

        [Parameter()]
        [switch]$OpenConfigFile
    )

    begin {
        $ITGlueConfig = Join-Path -Path $ITGlueConfigPath -ChildPath $ITGlueConfigFile
    }

    process {

        if (Test-Path -Path $ITGlueConfig) {

            if($OpenConfigFile) {
                Invoke-Item -Path $ITGlueConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $ITGlueConfigPath -FileName $ITGlueConfigFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $ITGlueConfig ]"
        }

    }

    end {}

}