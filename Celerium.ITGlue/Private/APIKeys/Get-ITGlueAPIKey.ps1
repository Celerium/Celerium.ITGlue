function Get-ITGlueAPIKey {
<#
    .SYNOPSIS
        Gets the ITGlue API key

    .DESCRIPTION
        The Get-ITGlueAPIKey cmdlet gets the ITGlue API key from
        the global variable and returns it as a SecureString

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-ITGlueAPIKey

        Gets the Api key and returns it as a SecureString

    .EXAMPLE
        Get-ITGlueAPIKey -AsPlainText

        Gets and decrypts the API key from the global variable and
        returns the API key as plain text

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($ITGlueModuleApiKey) {

                if ($AsPlainText) {
                    $ApiKey = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ITGlueModuleApiKey)

                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ApiKey) ).ToString()

                }
                else { $ITGlueModuleApiKey }

            }
            else { Write-Warning "The ITGlue API [ secret ] key is not set. Run Add-ITGlueAPIKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($ApiKey) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKey)
            }
        }


    }

    end {}

}