function Add-ITGlueAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls

    .DESCRIPTION
        The Add-ITGlueAPIKey cmdlet sets your API key which is used to
        authenticate all API calls made to ITGlue

        ITGlue API keys can be generated via the ITGlue web interface
            Account > API Keys

    .PARAMETER ApiKey
        Plain text API key

        If not defined the cmdlet will prompt you to enter the API key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Add-ITGlueAPIKey

        Prompts to enter in the API key which will be stored as a SecureString

    .EXAMPLE
        Add-ITGlueAPIKey -ApiKey '12345'

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        'Celerium@Celerium.org' | Add-ITGlueAPIKey

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        Add-ITGlueAPIKey -EncryptedStandardAPIKeyFilePath 'C:\path\to\encrypted\key.txt' -EncryptedStandardAESKeyPath 'C:\path\to\decipher\key.txt'

        Decrypts the AES API key and stores it in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'AsPlainText')]
    [Alias('Set-ITGlueAPIKey')]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'AsPlainText')]
        [AllowEmptyString()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString
    )

    begin {}

    process{

        switch ($PSCmdlet.ParameterSetName) {

            'AsPlainText' {

                if ($ApiKey) {
                    $SecureString = ConvertTo-SecureString $ApiKey -AsPlainText -Force

                    Set-Variable -Name "ITGlueModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "ITGlueModuleApiKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }

            }

            'SecureString' { Set-Variable -Name "ITGlueModuleApiKey" -Value $ApiKeySecureString -Option ReadOnly -Scope global -Force }

        }

    }

    end {}

}