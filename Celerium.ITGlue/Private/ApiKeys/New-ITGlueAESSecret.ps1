function New-ITGlueAESSecret {
<#
    .SYNOPSIS
        Creates a AES encrypted API key and decipher key

    .DESCRIPTION
        The New-ITGlueAESSecret cmdlet creates a AES encrypted API key and decipher key

        This allows the key to be exported for use on other systems without
        relying on Windows DPAPI

        Do NOT share the decipher key with anyone as this will allow them to decrypt
        the encrypted API key

    .PARAMETER KeyLength
        The length of the AES key to generate

        By default a 256-bit key (32) is generated

        Allowed values:
        16, 24, 32

    .PARAMETER Path
        The path to save the encrypted API key and decipher key

        By default keys are only stored in memory

    .EXAMPLE
        New-ITGlueAESSecret

        Prompts to enter in the API key which will be encrypted using a randomly generated 256-bit AES key


    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/New-ITGlueAESSecret.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [Alias('Set-ITGlueAPIKey')]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateSet(16, 24, 32)]
        [int]$KeyLength = 32,

        [Parameter(Mandatory = $false)]
        [string]$Path = $(Get-Location).Path
    )

    begin {}

    process{

        $AESKey = Get-Random -Count $KeyLength -InputObject (0..255)

        Write-Output "Please enter your API key:"
        $SecureString = Read-Host -AsSecureString

        $EncryptedStandardString    = ConvertFrom-SecureString -SecureString $SecureString -Key $AESKey
        $AESSecuredKey              = $EncryptedStandardString | ConvertTo-SecureString -Key $AESKey

        if ($Path) {
            $AESKey                     | Out-File -FilePath $(Join-Path -Path $Path -ChildPath AESKey) -Encoding utf8
            $EncryptedStandardString    | Out-File -FilePath $(Join-Path -Path $Path -ChildPath EncryptedAPIKey) -Encoding utf8

            Write-Warning "Store the AES key in a secure location that only authorized personnel have access to!"

            Write-Output "Files saved to [ $Path ]"

        }
        else {
            [PSCustomObject]@{
                AESKey              = $AESKey
                AESStandardString   = $EncryptedStandardString
                AESSecureString     = $AESSecuredKey
            }
        }

    }

    end {}

}