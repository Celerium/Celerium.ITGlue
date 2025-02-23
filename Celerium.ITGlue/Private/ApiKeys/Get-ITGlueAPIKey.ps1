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

        Gets the ITGlue API secret key global variable and returns an object
        with the secret key as a SecureString

    .EXAMPLE
        Get-ITGlueAPIKey -AsPlainText

        Gets the ITGlue API secret key global variable and returns an object
        with the secret key as plain text

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueAPIKey.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($ITGlueModuleAPIKey) {

                if ($AsPlainText) {
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ITGlueModuleAPIKey)

                    ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key)).ToString()

                }
                else { $ITGlueModuleAPIKey }

            }
            else { Write-Warning "The ITGlue API [ secret ] key is not set. Run Add-ITGlueAPIKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }


    }

    end {}

}