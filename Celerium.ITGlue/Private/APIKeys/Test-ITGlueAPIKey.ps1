function Test-ITGlueAPIKey {
<#
    .SYNOPSIS
        Test the ITGlue API key

    .DESCRIPTION
        The Test-ITGlueAPIKey cmdlet tests the base URI & API key that are defined
        in the Add-ITGlueBaseURI & Add-ITGlueAPIKey cmdlets

        Helpful when needing to validate general functionality or when using
        RMM deployment tools

        The ITGlue Regions endpoint is called in this test

    .PARAMETER BaseUri
        Define the base URI for the ITGlue API connection
        using ITGlue's URI or a custom URI

        By default the value used is the one defined by Add-ITGlueBaseURI function
            'https://api.itglue.com'

    .EXAMPLE
        Test-ITGlueAPIKey

        Tests the base URI & API key that are defined in the
        Add-ITGlueBaseURI & Add-ITGlueAPIKey cmdlets

    .EXAMPLE
        Test-ITGlueAPIKey -BaseUri http://myapi.gateway.example.com

        Tests the defined base URI & API key that was defined in
        the Add-ITGlueAPIKey cmdlet

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/regions

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Test-ITGlueAPIKey.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri = $ITGlueModuleBaseURI
    )

    begin { $ResourceUri = "/regions" }

    process {

        Write-Verbose "Testing API key against [ $($BaseUri + $ResourceUri) ]"

        try {

            $ITGlue_Headers = @{}
            $ITGlue_Headers.Add('x-api-key', $(Get-ITGlueAPIKey -AsPlainText) )

            $rest_output = Invoke-WebRequest -Method Get -Uri ($BaseUri + $ResourceUri) -Headers $ITGlue_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method              = $_.Exception.Response.Method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($BaseUri + $ResourceUri)
            }

        } finally {
            [void] ($ITGlue_Headers.Remove('x-api-key'))
        }

        if ($rest_output) {
            $Data = @{}
            $Data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $Data.StatusCode
                StatusDescription   = $Data.StatusDescription
                URI                 = $($BaseUri + $ResourceUri)
            }
        }

    }

    end {}

}