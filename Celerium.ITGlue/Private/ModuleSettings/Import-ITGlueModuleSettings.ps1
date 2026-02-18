function Import-ITGlueModuleSettings {
<#
    .SYNOPSIS
        Imports the ITGlue BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-ITGlueModuleSettings cmdlet imports the ITGlue BaseURI, API, & JSON configuration
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
        Import-ITGlueModuleSettings

        Validates that the configuration file created with the Export-ITGlueModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the ITGlue configuration file is:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Import-ITGlueModuleSettings -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1

        Validates that the configuration file created with the Export-ITGlueModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the ITGlue configuration file in this example is:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Import-ITGlueModuleSettings.html
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

        switch ($PSVersionTable.PSEdition){
            'Core'      { $UserAgent = "Celerium.ITGlue/1.2.0 - PowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.Platform) $($PSVersionTable.OS))" }
            'Desktop'   { $UserAgent = "Celerium.ITGlue/1.2.0 - WindowsPowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.BuildVersion))" }
            default     { $UserAgent = "Celerium.ITGlue/1.2.0 - $([Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{$_.Name -eq 'UserAgent'}.GetValue($null,$null))" }
        }

    }

    process {

        if (Test-Path $ITGlueConfig) {
            $TempConfig = Import-LocalizedData -BaseDirectory $ITGlueConfigPath -FileName $ITGlueConfigFile

            # Send to function to strip potentially superfluous slash (/)
            Add-ITGlueBaseURI $TempConfig.ITGlueModuleBaseURI

            $TempConfig.ITGlueModuleApiKey = ConvertTo-SecureString $TempConfig.ITGlueModuleApiKey

            Set-Variable -Name "ITGlueModuleApiKey" -Value $TempConfig.ITGlueModuleApiKey -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "ITGlueModuleUserAgent" -Value $TempConfig.ITGlueModuleUserAgent -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "ITGlueModuleJSONConversionDepth" -Value $TempConfig.ITGlueModuleJSONConversionDepth  -Option ReadOnly -Scope Global -Force

            Write-Verbose "Celerium.ITGlue Module configuration loaded successfully from [ $ITGlueConfig ]"

            # Clean things up
            Remove-Variable "TempConfig"
        }
        else {
            Write-Verbose "No configuration file found at [ $ITGlueConfig ] run Add-ITGlueAPIKey to get started."

            Add-ITGlueBaseURI

            Set-Variable -Name "ITGlueModuleBaseURI" -Value $(Get-ITGlueBaseURI) -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "ITGlueModuleUserAgent" -Value $UserAgent -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "ITGlueModuleJSONConversionDepth" -Value 100 -Option ReadOnly -Scope Global -Force
        }

    }

    end {}

}