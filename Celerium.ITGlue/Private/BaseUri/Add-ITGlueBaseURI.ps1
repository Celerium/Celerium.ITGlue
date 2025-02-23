function Add-ITGlueBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the ITGlue API connection

    .DESCRIPTION
        The Add-ITGlueBaseURI cmdlet sets the base URI which is used
        to construct the full URI for all API calls

    .PARAMETER BaseUri
        Sets the base URI for the ITGlue API connection. Helpful
        if using a custom API gateway

        The default value is 'https://api.itglue.com'

    .PARAMETER DataCenter
        Defines the data center to use which in turn defines which
        base API URL is used

        Allowed values:
        'US', 'EU', 'AU'

            'US' = 'https://api.itglue.com'
            'EU' = 'https://api.eu.itglue.com'
            'AU' = 'https://api.au.itglue.com'

    .EXAMPLE
        Add-ITGlueBaseURI

        The base URI will use https://api.itglue.com

    .EXAMPLE
        Add-ITGlueBaseURI -BaseUri 'https://my.gateway.com'

        The base URI will use https://my.gateway.com

    .EXAMPLE
        'https://my.gateway.com' | Add-ITGlueBaseURI

        The base URI will use https://my.gateway.com

    .EXAMPLE
        Add-ITGlueBaseURI -DataCenter EU

        The base URI will use https://api.eu.itglue.com

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueBaseURI.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding()]
    [Alias('Set-ITGlueBaseURI')]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$BaseUri = 'https://api.itglue.com',

        [ValidateSet( 'AU', 'EU', 'US')]
        [string]$DataCenter
    )

    process{

        if($BaseUri[$BaseUri.Length-1] -eq "/") {
            $BaseUri = $BaseUri.Substring(0,$BaseUri.Length-1)
        }

        switch ($DataCenter) {
            'AU' {$BaseUri = 'https://api.au.itglue.com'}
            'EU' {$BaseUri = 'https://api.eu.itglue.com'}
            'US' {$BaseUri = 'https://api.itglue.com'}
            Default {}
        }

        Set-Variable -Name "ITGlueModuleBaseURI" -Value $BaseUri -Option ReadOnly -Scope global -Force

    }

}