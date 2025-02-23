#Region '.\Private\ApiCalls\ConvertTo-ITGlueQueryString.ps1' -1

function ConvertTo-ITGlueQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The ConvertTo-ITGlueQueryString cmdlet converts & formats uri query parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-ITGlueRequest & any public functions that define parameters

    .PARAMETER QueryParams
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

    .EXAMPLE
        ConvertTo-ITGlueQueryString -QueryParams $HashTable

        Example HashTable:
            $query_params = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/ConvertTo-ITGlueQueryString.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$QueryParams
    )

    begin {}

    process{

        if (-not $QueryParams) {
            return ""
        }

        $params = @()
        foreach ($key in $QueryParams.Keys) {
            $value = [System.Net.WebUtility]::UrlEncode($QueryParams[$key])
            $params += "$key=$value"
        }

        $query_string = '?' + ($params -join '&')
        return $query_string

    }

    end{}

}
#EndRegion '.\Private\ApiCalls\ConvertTo-ITGlueQueryString.ps1' 67
#Region '.\Private\ApiCalls\Invoke-ITGlueRequest.ps1' -1

function Invoke-ITGlueRequest {
<#
    .SYNOPSIS
        Makes an API request to ITGlue

    .DESCRIPTION
        The Invoke-ITGlueRequest cmdlet invokes an API request to the ITGlue API

        This is an internal function that is used by all public functions

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET', 'POST', 'PATCH', 'DELETE'

    .PARAMETER ResourceURI
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER QueryParams
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $ITGlueModuleBaseURI + $ResourceURI + ConvertTo-ITGlueQueryString

    .PARAMETER Data
        Object containing supported ITGlue method schemas

        Commonly used when bulk adjusting ITGlue data

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Invoke-ITGlueRequest -method GET -ResourceURI '/passwords' -QueryParams $QueryParams

        Invoke a rest method against the defined resource using the provided parameters

        Example HashTable:
            $query_params = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Invoke-ITGlueRequest.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter(Mandatory = $true)]
        [string]$ResourceURI,

        [Parameter()]
        [hashtable]$QueryParams,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $Data,

        [Parameter()]
        [switch]$AllResults
    )

    begin {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Write-Verbose 'TEST -- Loading System.Web assembly'
            Add-Type -Assembly System.Web
        }

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $result = @{}

        switch ([bool]$Data) {
            $true   { $body = @{'data'=$Data} | ConvertTo-Json -Depth $ITGlueModuleJSONConversionDepth }
            $false  { $body = $null }
        }

        try {

            $headers = @{ 'x-api-key' = Get-ITGlueAPIKey -AsPlainText }

            $page = 0

            do {

                $page++

                if($AllResults) {
                    if(-not $QueryParams) { $QueryParams = @{} }
                    $QueryParams['page[number]'] = $page
                }

                if ($QueryParams) {
                    $query_string = ConvertTo-ITGlueQueryString -QueryParams $QueryParams
                    Set-Variable -Name $QueryParameterName -Value $query_string -Scope Global -Force -Confirm:$false
                }

                $parameters = @{
                    'Method'    = $Method
                    'Uri'       = $ITGlueModuleBaseURI + $ResourceURI + $query_string
                    'Headers'   = $headers
                    'Body'      = $body
                }

                if($Method -ne 'GET') {
                    $parameters['ContentType'] = 'application/vnd.api+json; charset=utf-8'
                }

                Set-Variable -Name $ParameterName -Value $parameters -Scope Global -Force -Confirm:$false

                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop

                Write-Verbose "[ $page ] of [ $($api_response.meta.'total-pages') ] pages"

                switch ($AllResults) {
                    $true   { $result.data += $api_response.data }
                    $false  { $result = $api_response }
                }

            } while($AllResults -and $api_response.meta.'total-pages' -and $page -lt ($api_response.meta.'total-pages'))

            if($AllResults -and $api_response.meta) {
                $result.meta = $api_response.meta
                if($result.meta.'current-page') { $result.meta.'current-page'   = 1 }
                if($result.meta.'next-page')    { $result.meta.'next-page'      = '' }
                if($result.meta.'prev-page')    { $result.meta.'prev-page'      = '' }
                if($result.meta.'total-pages')  { $result.meta.'total-pages'    = 1 }
                if($result.meta.'total-count')  { $result.meta.'total-count'    = $result.data.count }
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Invoke_ITGlueRequest_Parameters, Invoke_ITGlueRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*404*' { Write-Error "Invoke-ITGlueRequest : URI not found - [ $ResourceURI ]" }
                '*429*' { Write-Error 'Invoke-ITGlueRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-ITGlueRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }
        }
        finally{

            $Auth = $Invoke_ITGlueRequest_Parameters['headers']['x-api-key']
            $Invoke_ITGlueRequest_Parameters['headers']['x-api-key'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }

        return $result

    }

    end {}

}
#EndRegion '.\Private\ApiCalls\Invoke-ITGlueRequest.ps1' 184
#Region '.\Private\ApiKeys\Add-ITGlueAPIKey.ps1' -1

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

    .PARAMETER EncryptedStandardAPIKeyPath
        Path to the AES standard encrypted API key file

    .PARAMETER EncryptedStandardAESKeyPath
        Path to the AES key file

    .EXAMPLE
        Add-ITGlueAPIKey

        Prompts to enter in the API key which will be stored as a SecureString

    .EXAMPLE
        Add-ITGlueAPIKey -ApiKey 'some_api_key'

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        '12345' | Add-ITGlueAPIKey

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        Add-ITGlueAPIKey -EncryptedStandardAPIKeyFilePath 'C:\path\to\encrypted\key.txt' -EncryptedStandardAESKeyPath 'C:\path\to\decipher\key.txt'

        Decrypts the AES API key and stores it in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Add-ITGlueAPIKey.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding(DefaultParameterSetName = 'PlainText')]
    [Alias('Set-ITGlueAPIKey')]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'PlainText')]
        [AllowEmptyString()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString,

        [Parameter(Mandatory = $false, ParameterSetName = 'EncryptedByFile')]
        [ValidateScript({
            if (Test-Path $_) { $true }
            else { throw "The file path provided does not exist - [  $_  ]" }
        })]
        [string]$EncryptedStandardAPIKeyPath,

        [Parameter(Mandatory = $true, ParameterSetName = 'EncryptedByFile')]
        [ValidateScript({
            if (Test-Path $_) { $true }
            else { throw "The file path provided does not exist - [  $_  ]" }
        })]
        [string]$EncryptedStandardAESKeyPath
    )

    begin {}

    process{

        switch ($PSCmdlet.ParameterSetName) {

            'PlainText' {

                if ($ApiKey) {
                    $SecureString = ConvertTo-SecureString $ApiKey -AsPlainText -Force

                    Set-Variable -Name "ITGlueModuleAPIKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "ITGlueModuleAPIKey" -Value $SecureString -Option ReadOnly -Scope global -Force
                }

            }

            'SecureString' { Set-Variable -Name "ITGlueModuleAPIKey" -Value $ApiKeySecureString -Option ReadOnly -Scope global -Force }

            'Encrypted' {

                $SecureString =  Get-Content $EncryptedStandardAPIKeyPath | ConvertTo-SecureString -Key $(Get-Content $EncryptedStandardAESKeyPath )

                Set-Variable -Name "ITGlueModuleAPIKey" -Value $SecureString -Option ReadOnly -Scope global -Force

            }

        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Add-ITGlueAPIKey.ps1' 124
#Region '.\Private\ApiKeys\Get-ITGlueAPIKey.ps1' -1

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
#EndRegion '.\Private\ApiKeys\Get-ITGlueAPIKey.ps1' 77
#Region '.\Private\ApiKeys\New-ITGlueAESSecret.ps1' -1

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
#EndRegion '.\Private\ApiKeys\New-ITGlueAESSecret.ps1' 90
#Region '.\Private\ApiKeys\Remove-ITGlueAPIKey.ps1' -1

function Remove-ITGlueAPIKey {
<#
    .SYNOPSIS
        Removes the ITGlue API key

    .DESCRIPTION
        The Remove-ITGlueAPIKey cmdlet removes the ITGlue API key from
        global variable

    .EXAMPLE
        Remove-ITGlueAPIKey

        Removes the ITGlue API key global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueAPIKey.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue

#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleAPIKey) {

            $true   {
                if ($PSCmdlet.ShouldProcess('ITGlueModuleAPIKey')) {
                Remove-Variable -Name "ITGlueModuleAPIKey" -Scope global -Force }
            }

            $false  { Write-Warning "The ITGlue API [ secret ] key is not set. Nothing to remove" }

        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Remove-ITGlueAPIKey.ps1' 49
#Region '.\Private\ApiKeys\Test-ITGlueAPIKey.ps1' -1

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
#EndRegion '.\Private\ApiKeys\Test-ITGlueAPIKey.ps1' 98
#Region '.\Private\BaseUri\Add-ITGlueBaseURI.ps1' -1

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
#EndRegion '.\Private\BaseUri\Add-ITGlueBaseURI.ps1' 85
#Region '.\Private\BaseUri\Get-ITGlueBaseURI.ps1' -1

function Get-ITGlueBaseURI {
<#
    .SYNOPSIS
        Shows the ITGlue base URI

    .DESCRIPTION
        The Get-ITGlueBaseURI cmdlet shows the ITGlue base URI from
        the global variable

    .EXAMPLE
        Get-ITGlueBaseURI

        Shows the ITGlue base URI value defined in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueBaseURI.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding()]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleBaseURI) {
            $true   { $ITGlueModuleBaseURI }
            $false  { Write-Warning "The ITGlue base URI is not set. Run Add-ITGlueBaseURI to set the base URI." }
        }

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Get-ITGlueBaseURI.ps1' 42
#Region '.\Private\BaseUri\Remove-ITGlueBaseURI.ps1' -1

function Remove-ITGlueBaseURI {
<#
    .SYNOPSIS
        Removes the ITGlue base URI global variable

    .DESCRIPTION
        The Remove-ITGlueBaseURI cmdlet removes the ITGlue base URI from
        the global variable

    .EXAMPLE
        Remove-ITGlueBaseURI

        Removes the ITGlue base URI value from the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueBaseURI.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$ITGlueModuleBaseURI) {

            $true   {
                if ($PSCmdlet.ShouldProcess('ITGlueModuleBaseURI')) {
                    Remove-Variable -Name "ITGlueModuleBaseURI" -Scope global -Force
                }
            }

            $false  { Write-Warning "The ITGlue base URI variable is not set. Nothing to remove" }

        }

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Remove-ITGlueBaseURI.ps1' 49
#Region '.\Private\ModuleSettings\Export-ITGlueModuleSetting.ps1' -1

function Export-ITGlueModuleSetting {
<#
    .SYNOPSIS
        Exports the ITGlue BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-ITGlueModuleSetting cmdlet exports the ITGlue BaseURI, API, & JSON configuration information to file

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
        Export-ITGlueModuleSetting

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's ITGlue configuration file located at:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Export-ITGlueModuleSetting -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's ITGlue configuration file located at:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Export-ITGlueModuleSetting.html

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

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $ITGlueConfig = Join-Path -Path $ITGlueConfigPath -ChildPath $ITGlueConfigFile

        # Confirm variables exist and are not null before exporting
        if ($ITGlueModuleBaseURI -and $ITGlueModuleAPIKey -and $ITGlueModuleJSONConversionDepth) {
            $SecureString = $ITGlueModuleAPIKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $ITGlueConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $ITGlueConfigPath -ItemType Directory -Force
            }
@"
    @{
        ITGlueModuleBaseURI             = '$ITGlueModuleBaseURI'
        ITGlueModuleAPIKey              = '$SecureString'
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
#EndRegion '.\Private\ModuleSettings\Export-ITGlueModuleSetting.ps1' 96
#Region '.\Private\ModuleSettings\Get-ITGlueModuleSetting.ps1' -1

function Get-ITGlueModuleSetting {
<#
    .SYNOPSIS
        Gets the saved ITGlue configuration settings

    .DESCRIPTION
        The Get-ITGlueModuleSetting cmdlet gets the saved ITGlue configuration settings
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
        Get-ITGlueModuleSetting

        Gets the contents of the configuration file that was created with the
        Export-ITGlueModuleSetting

        The default location of the ITGlue configuration file is:
            $env:USERPROFILE\Celerium.ITGlue\config.psd1

    .EXAMPLE
        Get-ITGlueModuleSetting -ITGlueConfigPath C:\Celerium.ITGlue -ITGlueConfigFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the ITGlue configuration file in this example is:
            C:\Celerium.ITGlue\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Get-ITGlueModuleSetting.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
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
#EndRegion '.\Private\ModuleSettings\Get-ITGlueModuleSetting.ps1' 92
#Region '.\Private\ModuleSettings\Import-ITGlueModuleSetting.ps1' -1

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
#EndRegion '.\Private\ModuleSettings\Import-ITGlueModuleSetting.ps1' 99
#Region '.\Private\ModuleSettings\Initialize-ITGlueModuleSetting.ps1' -1

#Used to auto load either baseline settings or saved configurations when the module is imported
Import-ITGlueModuleSetting -Verbose:$false
#EndRegion '.\Private\ModuleSettings\Initialize-ITGlueModuleSetting.ps1' 3
#Region '.\Private\ModuleSettings\Remove-ITGlueModuleSetting.ps1' -1

function Remove-ITGlueModuleSetting {
<#
    .SYNOPSIS
        Removes the stored ITGlue configuration folder

    .DESCRIPTION
        The Remove-ITGlueModuleSetting cmdlet removes the ITGlue folder and its files
        This cmdlet also has the option to remove sensitive ITGlue variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER ITGlueConfigPath
        Define the location of the ITGlue configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.ITGlue

    .PARAMETER WithVariables
        Define if sensitive ITGlue variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-ITGlueModuleSetting

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the ITGlue configuration folder is:
            $env:USERPROFILE\Celerium.ITGlue

    .EXAMPLE
        Remove-ITGlueModuleSetting -ITGlueConfigPath C:\Celerium.ITGlue -WithVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive ITGlue variables exist then they are removed as well

        The location of the ITGlue configuration folder in this example is:
            C:\Celerium.ITGlue

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Remove-ITGlueModuleSetting.html

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy',SupportsShouldProcess)]
    Param (
        [Parameter()]
        [string]$ITGlueConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.ITGlue"}else{".Celerium.ITGlue"}) ),

        [Parameter()]
        [switch]$WithVariables
    )

    begin {}

    process {

        if (Test-Path $ITGlueConfigPath) {

            Remove-Item -Path $ITGlueConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($WithVariables) {
                Remove-ITGlueAPIKey
                Remove-ITGlueBaseURI
            }

            if (!(Test-Path $ITGlueConfigPath)) {
                Write-Output "The Celerium.ITGlue configuration folder has been removed successfully from [ $ITGlueConfigPath ]"
            }
            else {
                Write-Error "The Celerium.ITGlue configuration folder could not be removed from [ $ITGlueConfigPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $ITGlueConfigPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Remove-ITGlueModuleSetting.ps1' 90
#Region '.\Public\Attachments\New-ITGlueAttachment.ps1' -1

function New-ITGlueAttachment {
<#
    .SYNOPSIS
        Adds an attachment to one or more assets

    .DESCRIPTION
        The New-ITGlueAttachment cmdlet adds an attachment
        to one or more assets

        Attachments are uploaded by including media data on the asset the attachment
        is associated with. Attachments can be encoded and passed in JSON format for
        direct upload, in which case the file has to be strict encoded

        Note that the name of the attachment will be taken from the file_name attribute
        placed in the JSON body

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
        'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -Data $JsonObject

        Creates an attachment to a password with the defined id using the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Attachments/New-ITGlueAttachment.html

    .LINK
        https://api.itglue.com/developer/#attachments-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents','domains', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets'
        )]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin{

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process{

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/attachments"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($Data)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\Attachments\New-ITGlueAttachment.ps1' 91
#Region '.\Public\Attachments\Remove-ITGlueAttachment.ps1' -1

function Remove-ITGlueAttachment {
<#
    .SYNOPSIS
        Deletes one or more specified attachments

    .DESCRIPTION
        The Remove-ITGlueAttachment cmdlet deletes one
        or more specified attachments

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
        'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -Data $JsonObject

        Using the defined JSON object this deletes an attachment from a
        password with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Attachments/Remove-ITGlueAttachment.html

    .LINK
        https://api.itglue.com/developer/#attachments-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets'
        )]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin{

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process{

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/attachments"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($Data)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\Attachments\Remove-ITGlueAttachment.ps1' 85
#Region '.\Public\Attachments\Set-ITGlueAttachment.ps1' -1

function Set-ITGlueAttachment {
<#
    .SYNOPSIS
        Updates the details of an existing attachment

    .DESCRIPTION
        The Set-ITGlueAttachment cmdlet updates the details of
        an existing attachment

        Only the attachment name that is displayed on the asset view
        screen can be changed

        The original file_name can't be changed

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
        'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER ID
        The resource id of the existing attachment

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -id 8675309 -Data $JsonObject

        Updates an attachment to a password with the defined id using the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Attachments/Set-ITGlueAttachment.html

    .LINK
        https://api.itglue.com/developer/#attachments-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet( 'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
                'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin{

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process{

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/attachments/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($Data)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\Attachments\Set-ITGlueAttachment.ps1' 93
#Region '.\Public\ConfigurationInterfaces\Get-ITGlueConfigurationInterface.ps1' -1

function Get-ITGlueConfigurationInterface {
<#
    .SYNOPSIS
        Retrieve a configuration(s) interface(s)

    .DESCRIPTION
        The Get-ITGlueConfigurationInterface cmdlet retrieves a
        configuration(s) interface(s)

        This function can call the following endpoints:
            Index = /configurations/:conf_id/relationships/configuration_interfaces

            Show =  /configuration_interfaces/:id
                    /configurations/:id/relationships/configuration_interfaces/:id

    .PARAMETER ConfigurationID
        A valid configuration ID in your account

    .PARAMETER FilterID
        Configuration id to filter by

    .PARAMETER FilterIPAddress
        IP address to filter by

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        A valid configuration interface ID in your account

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueConfigurationInterface -ConfigurationID 8765309

        Gets an index of all the defined configurations interfaces

    .EXAMPLE
        Get-ITGlueConfigurationInterface -ConfigurationID 8765309 -ID 8765309

        Gets an a defined interface from a defined configuration

    .EXAMPLE
        Get-ITGlueConfigurationInterface -ConfigurationID 8765309 -ID 8765309

        Gets a defined interface from a defined configuration

    .EXAMPLE
        Get-ITGlueConfigurationInterface -ID 8765309

        Gets a defined interface

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Get-ITGlueConfigurationInterface.html

    .LINK
        https://api.itglue.com/developer/#configuration-interfaces-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$ConfigurationID,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterIPAddress,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PsCmdlet.ParameterSetName) {
            'Index' {

                switch ([bool]$ConfigurationID) {
                    $true   { $ResourceUri = "/configurations/$ConfigurationID/relationships/configuration_interfaces" }
                    $false  { $ResourceUri = "/configuration_interfaces" }
                }

            }
            'Show'  {

                switch ([bool]$ConfigurationID) {
                    $true   { $ResourceUri = "/configurations/$ConfigurationID/relationships/configuration_interfaces/$ID" }
                    $false  { $ResourceUri = "/configuration_interfaces/$ID" }
                }

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)          { $query_params['filter[id]']           = $FilterID }
            if ($FilterIPAddress)   { $query_params['filter[ip_address]']   = $FilterIPAddress }
            if ($Sort)              { $query_params['sort']                 = $Sort }
            if ($PageNumber)        { $query_params['page[number]']         = $PageNumber}
            if ($PageSize)          { $query_params['page[size]']           = $PageSize}
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\ConfigurationInterfaces\Get-ITGlueConfigurationInterface.ps1' 165
#Region '.\Public\ConfigurationInterfaces\New-ITGlueConfigurationInterface.ps1' -1

function New-ITGlueConfigurationInterface {
<#
    .SYNOPSIS
        Creates one or more configuration interfaces for a particular configuration(s)

    .DESCRIPTION
        The New-ITGlueConfigurationInterface cmdlet creates one or more configuration
        interfaces for a particular configuration(s)

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ConfigurationID
        A valid configuration ID in your account



    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueConfigurationInterface -ConfigurationID 8765309 -Data $JsonObject

        Creates a configuration interface for the defined configuration using the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/New-ITGlueConfigurationInterface.html

    .LINK
        https://api.itglue.com/developer/#configuration-interfaces-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$ConfigurationID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$ConfigurationID) {
            $true   { $ResourceUri = "/configurations/$ConfigurationID/relationships/configuration_interfaces" }
            $false  { $ResourceUri = "/configuration_interfaces" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationInterfaces\New-ITGlueConfigurationInterface.ps1' 75
#Region '.\Public\ConfigurationInterfaces\Set-ITGlueConfigurationInterface.ps1' -1

function Set-ITGlueConfigurationInterface {
<#
    .SYNOPSIS
        Update one or more configuration interfaces

    .DESCRIPTION
        The Set-ITGlueConfigurationInterface cmdlet updates one
        or more configuration interfaces

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update =    /configuration_interfaces/:id
                        /configurations/:conf_id/relationships/configuration_interfaces/:id

            Bulk_Update =   /configuration_interfaces
                            /configurations/:conf_id/relationships/configuration_interfaces/:id

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        A valid configuration interface ID in your account

        Example: 12345

    .PARAMETER ConfigurationID
        A valid configuration ID in your account



    .PARAMETER FilterID
        Configuration id to filter by



    .PARAMETER FilterIPAddress
        Filter by an IP4 or IP6 address

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueConfigurationInterface -ID 8765309 -Data $JsonObject

        Updates an interface for the defined configuration with the structured
        JSON object

    .EXAMPLE
        Set-ITGlueConfigurationInterface -FilterID 8765309 -Data $JsonObject

        Bulk updates interfaces associated to the defined configuration filter
        with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Set-ITGlueConfigurationInterface.html

    .LINK
        https://api.itglue.com/developer/#configuration-interfaces-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$ConfigurationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [string]$FilterIPAddress,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PsCmdlet.ParameterSetName) {
            'Bulk_Update'  { $ResourceUri = "/configuration_interfaces" }
            'Update' {

                switch ([bool]$ConfigurationID) {
                    $true   { $ResourceUri = "/configurations/$ConfigurationID/relationships/configuration_interfaces/$ID" }
                    $false  { $ResourceUri = "/configuration_interfaces/$ID" }
                }

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update') {
            if ($FilterID)          { $query_params['filter[id]']           = $FilterID }
            if ($FilterIPAddress)   { $query_params['filter[ip_address]']   = $FilterIPAddress }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationInterfaces\Set-ITGlueConfigurationInterface.ps1' 134
#Region '.\Public\Configurations\Get-ITGlueConfiguration.ps1' -1

function Get-ITGlueConfiguration {
<#
    .SYNOPSIS
        List all configurations in an account or organization

    .DESCRIPTION
        The Get-ITGlueConfiguration cmdlet lists all configurations
        in an account or organization

        This function can call the following endpoints:
            Index = /configurations
                    /organizations/:organization_id/relationships/configurations

            Show =  /configurations/:id
                    /organizations/:organization_id/relationships/configurations/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER FilterID
        Filter by configuration id

    .PARAMETER FilterName
        Filter by configuration name

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterConfigurationTypeID
        Filter by configuration type id

    .PARAMETER FilterConfigurationStatusID
        Filter by configuration status id

    .PARAMETER FilterContactID
        Filter by contact id

    .PARAMETER FilterSerialNumber
        Filter by a configurations serial number

    .PARAMETER FilterMacAddress
        Filter by a configurations mac address

    .PARAMETER FilterAssetTag
        Filter by a configurations asset tag

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterRmmID
        Filter by a RMM id

    .PARAMETER FilterRmmIntegrationType
        Filter by a RMM integration type

        Allowed values:
        'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated-at',
        '-name', '-id', '-created_at', '-updated-at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, tickets ,configuration_interfaces,
        dnet_fa_remote_assets, group_resource_accesses ,rmm_records, passwords,
        user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        active_network_glue_network_devices ,adapters_resources_errors ,authorized_users
        from_configuration_connections, recent_versions, related_items ,rmm_adapters_resources
        rmm_adapters_resources_errors, to_configuration_connections

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueConfigurations

        Returns the first 50 configurations from your ITGlue account

    .EXAMPLE
        Get-ITGlueConfiguration -FilterOrganizationID 8765309

        Returns the first 50 configurations from the defined organization

    .EXAMPLE
        Get-ITGlueConfiguration -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for configurations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Get-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true ,Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Index_RMM_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated-at',
                        '-name', '-id', '-created_at', '-updated-at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'active_network_glue_network_devices', 'adapters_resources', 'adapters_resources_errors',
                        'attachments', 'authorized_users', 'configuration_interfaces', 'dnet_fa_remote_assets',
                        'from_configuration_connections', 'group_resource_accesses', 'passwords', 'recent_versions',
                        'related_items', 'rmm_adapters_resources', 'rmm_adapters_resources_errors', 'rmm_records',
                        'tickets', 'to_configuration_connections', 'user_resource_accesses'
        )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_RMM')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Index_RMM_PSA')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"


        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Index*'   {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations"}
                    $false  { $ResourceUri = "/configurations" }
                }

            }
            'Show'      {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations/$ID"}
                    $false  { $ResourceUri = "/configurations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Index*') {
            if ($FilterID)                      { $query_params['filter[id]']                       = $FilterID }
            if ($FilterName)                    { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)          { $query_params['filter[organization_id]']          = $FilterOrganizationID }
            if ($FilterConfigurationTypeID)     { $query_params['filter[configuration_type_id]']    = $FilterConfigurationTypeID }
            if ($FilterConfigurationStatusID)   { $query_params['filter[configuration_status_id]']  = $FilterConfigurationStatusID }
            if ($FilterContactID)               { $query_params['filter[contact_id]']               = $FilterContactID }
            if ($FilterSerialNumber)            { $query_params['filter[serial_number]']            = $FilterSerialNumber }
            if ($FilterMacAddress)              { $query_params['filter[mac_address]']              = $FilterMacAddress }
            if ($FilterAssetTag)                { $query_params['filter[asset_tag]']                = $FilterAssetTag }
            if ($FilterPsaIntegrationType)      { $query_params['filter[psa_integration_type]']     = $FilterPsaIntegrationType }
            if ($FilterRmmIntegrationType)      { $query_params['filter[rmm_integration_type]']     = $FilterRmmIntegrationType }
            if ($FilterArchived)                { $query_params['filter[archived]']                 = $FilterArchived }
            if ($Sort)                          { $query_params['sort']                             = $Sort }
            if ($PageNumber)                    { $query_params['page[number]']                     = $PageNumber }
            if ($PageSize)                      { $query_params['page[size]']                       = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -like 'Index_RMM*') {
                $query_params['filter[rmm_id]'] = $FilterRmmID
        }
        if ($PSCmdlet.ParameterSetName -like '*_PSA') {
                $query_params['filter[psa_id]'] = $FilterPsaID
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}
}
#EndRegion '.\Public\Configurations\Get-ITGlueConfiguration.ps1' 358
#Region '.\Public\Configurations\New-ITGlueConfiguration.ps1' -1

function New-ITGlueConfiguration {
<#
    .SYNOPSIS
        Creates one or more configurations

    .DESCRIPTION
        The New-ITGlueConfiguration cmdlet creates one or more
        configurations under a defined organization

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueConfiguration -OrganizationID 8675309 -Data $JsonObject

        Creates a configuration in the defined organization with the
        with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/new-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$OrganizationID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations" }
            $false  { $ResourceUri = "/configurations" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Configurations\New-ITGlueConfiguration.ps1' 74
#Region '.\Public\Configurations\Remove-ITGlueConfiguration.ps1' -1

function Remove-ITGlueConfiguration {
<#
    .SYNOPSIS
        Deletes one or more configurations

    .DESCRIPTION
        The Remove-ITGlueConfiguration cmdlet deletes one or
        more specified configurations

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER FilterID
        Filter by configuration id

    .PARAMETER FilterName
        Filter by configuration name

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterConfigurationTypeID
        Filter by configuration type id

    .PARAMETER FilterConfigurationStatusID
        Filter by configuration status id

    .PARAMETER FilterContactID
        Filter by contact id

    .PARAMETER FilterSerialNumber
        Filter by a configurations serial number

    .PARAMETER FilterMacAddress
        Filter by a configurations mac address

    .PARAMETER FilterAssetTag
        Filter by a configurations asset tag

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterRmmID
        Filter by a RMM id

    .PARAMETER FilterRmmIntegrationType
        Filter by a RMM integration type

        Allowed values:
        'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueConfiguration -ID 8765309 -Data $JsonObject

        Deletes a defined configuration with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Remove-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_RMM_PSA', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/configurations/$OrganizationID/relationships/configurations" }
            $false  { $ResourceUri = "/configurations" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                      { $query_params['filter[id]']                       = $FilterID }
            if ($FilterName)                    { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)          { $query_params['filter[organization_id]']          = $FilterOrganizationID }
            if ($FilterConfigurationTypeID)     { $query_params['filter[configuration_type_id]']    = $FilterConfigurationTypeID }
            if ($FilterConfigurationStatusID)   { $query_params['filter[configuration_status_id]']  = $FilterConfigurationStatusID }
            if ($FilterContactID)               { $query_params['filter[contact_id]']               = $FilterContactID }
            if ($FilterSerialNumber)            { $query_params['filter[serial_number]']            = $FilterSerialNumber }
            if ($FilterMacAddress)              { $query_params['filter[mac_address]']              = $FilterMacAddress }
            if ($FilterAssetTag)                { $query_params['filter[asset_tag]']                = $FilterAssetTag }
            if ($FilterPsaIntegrationType)      { $query_params['filter[psa_integration_type]']     = $FilterPsaIntegrationType }
            if ($FilterRmmIntegrationType)      { $query_params['filter[rmm_integration_type]']     = $FilterRmmIntegrationType }
            if ($FilterArchived)                { $query_params['filter[archived]']                 = $FilterArchived }
        }

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy_RMM*') {
            if ($FilterRmmID) {$query_params['filter[rmm_id]'] = $FilterRmmID}
        }
        if ($PSCmdlet.ParameterSetName -like '*_PSA') {
            if ($FilterPsaID) {$query_params['filter[psa_id]'] = $FilterPsaID}
        }

        if ($PSCmdlet.ParameterSetName -eq 'Destroy') {
            $Data = @(
                @{
                    type = 'configurations'
                    attributes = @{
                        id = $ID
                    }
                }
            )
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Configurations\Remove-ITGlueConfiguration.ps1' 249
#Region '.\Public\Configurations\Set-ITGlueConfiguration.ps1' -1

function Set-ITGlueConfiguration {
<#
    .SYNOPSIS
        Updates one or more configurations

    .DESCRIPTION
        The Set-ITGlueConfiguration cmdlet updates the details
        of one or more existing configurations

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update = /configurations/:id
                    /organizations/:organization_id/relationships/configurations/:id

            Bulk_Update =  /configurations

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        A valid configuration Id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by configuration id

    .PARAMETER FilterName
        Filter by configuration name

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterConfigurationTypeID
        Filter by configuration type id

    .PARAMETER FilterConfigurationStatusID
        Filter by configuration status id

    .PARAMETER FilterContactID
        Filter by contact id

    .PARAMETER FilterSerialNumber
        Filter by a configurations serial number

    .PARAMETER FilterMacAddress
        Filter by a configurations mac address

    .PARAMETER FilterAssetTag
        Filter by a configurations asset tag

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterRmmID
        Filter by a RMM id

    .PARAMETER FilterRmmIntegrationType
        Filter by a RMM integration type

        Allowed values:
        'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
        'pulseway-rmm', 'syncro', 'watchman-monitoring'

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueConfiguration -ID 8765309 -OrganizationID 8765309 -Data $JsonObject

        Updates a defined configuration in the defined organization with
        the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Configurations/Set-ITGlueConfiguration.html

    .LINK
        https://api.itglue.com/developer/#configurations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterConfigurationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterConfigurationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [int64]$FilterContactID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterSerialNumber,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterMacAddress,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterAssetTag,

        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [string]$FilterRmmID,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA', Mandatory = $true)]
        [ValidateSet(   'addigy', 'aem', 'atera', 'auvik', 'managed-workplace',
                        'continuum', 'jamf-pro', 'kaseya-vsa', 'automate', 'log-me-in',
                        'msp-rmm', 'meraki', 'msp-n-central', 'ninja-rmm', 'panorama9',
                        'pulseway-rmm', 'syncro', 'watchman-monitoring','office365','vsa-x'
        )]
        [string]$FilterRmmIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update_RMM')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [Parameter(ParameterSetName = 'Bulk_Update_RMM_PSA')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_rmm', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_psa', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_rmm_psa', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"


        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Bulk_Update*'  { $ResourceUri = "/configurations" }
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/configurations/$ID"}
                    $false  { $ResourceUri = "/configurations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update*') {
            if ($FilterID)                      { $query_params['filter[id]']                       = $FilterID }
            if ($FilterName)                    { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)          { $query_params['filter[organization_id]']          = $FilterOrganizationID }
            if ($FilterConfigurationTypeID)     { $query_params['filter[configuration_type_id]']    = $FilterConfigurationTypeID }
            if ($FilterConfigurationStatusID)   { $query_params['filter[configuration_status_id]']  = $FilterConfigurationStatusID }
            if ($FilterContactID)               { $query_params['filter[contact_id]']               = $FilterContactID }
            if ($FilterSerialNumber)            { $query_params['filter[serial_number]']            = $FilterSerialNumber }
            if ($FilterMacAddress)              { $query_params['filter[mac_address]']              = $FilterMacAddress }
            if ($FilterAssetTag)                { $query_params['filter[asset_tag]']                = $FilterAssetTag }
            if ($FilterPsaIntegrationType)      { $query_params['filter[psa_integration_type]']     = $FilterPsaIntegrationType }
            if ($FilterRmmIntegrationType)      { $query_params['filter[rmm_integration_type]']     = $FilterRmmIntegrationType }
            if ($FilterArchived)                { $query_params['filter[archived]']                 = $FilterArchived }
        }

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update_RMM*') {
            if ($FilterRmmID) {$query_params['filter[rmm_id]'] = $FilterRmmID}
        }
        if ($PSCmdlet.ParameterSetName -like '*_PSA') {
            if ($FilterPsaID) {$query_params['filter[psa_id]'] = $FilterPsaID}
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Configurations\Set-ITGlueConfiguration.ps1' 260
#Region '.\Public\ConfigurationStatuses\Get-ITGlueConfigurationStatus.ps1' -1

function Get-ITGlueConfigurationStatus {
<#
    .SYNOPSIS
        List or show all configuration(s) statuses

    .DESCRIPTION
        The Get-ITGlueConfigurationStatus cmdlet lists all or shows a
        defined configuration(s) status

        This function can call the following endpoints:
            Index = /configuration_statuses

            Show =  /configuration_statuses/:id

    .PARAMETER FilterName
        Filter by configuration status name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a configuration status by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueConfigurationStatus

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueConfigurationStatus -ID 8765309

        Returns the configuration status with the defined id

    .EXAMPLE
        Get-ITGlueConfigurationStatus -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for configuration status
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Get-ITGlueConfigurationStatus.html

    .LINK
        https://api.itglue.com/developer/#configuration-statuses-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/configuration_statuses" }
            'Show'  { $ResourceUri = "/configuration_statuses/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion   [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\ConfigurationStatuses\Get-ITGlueConfigurationStatus.ps1' 133
#Region '.\Public\ConfigurationStatuses\New-ITGlueConfigurationStatus.ps1' -1

function New-ITGlueConfigurationStatus {
<#
    .SYNOPSIS
        Creates a configuration status

    .DESCRIPTION
        The New-ITGlueConfigurationStatus cmdlet creates a new configuration
        status in your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueConfigurationStatus -Data $JsonObject

        Creates a new configuration status with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/New-ITGlueConfigurationStatus.html

    .LINK
        https://api.itglue.com/developer/#configuration-statuses-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/configuration_statuses"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationStatuses\New-ITGlueConfigurationStatus.ps1' 64
#Region '.\Public\ConfigurationStatuses\Set-ITGlueConfigurationStatus.ps1' -1

function Set-ITGlueConfigurationStatus {
<#
    .SYNOPSIS
        Updates a configuration status

    .DESCRIPTION
        The Set-ITGlueConfigurationStatus cmdlet updates a configuration
        status in your account

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Get a configuration status by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueConfigurationStatus -id 8675309 -Data $JsonObject

        Updates the defined configuration status with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationStatuses/Set-ITGlueConfigurationStatus.html

    .LINK
        https://api.itglue.com/developer/#configuration-statuses-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/configuration_statuses/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationStatuses\Set-ITGlueConfigurationStatus.ps1' 72
#Region '.\Public\ConfigurationTypes\Get-ITGlueConfigurationType.ps1' -1

function Get-ITGlueConfigurationType {
<#
    .SYNOPSIS
        List or show all configuration type(s)

    .DESCRIPTION
        The Get-ITGlueConfigurationType cmdlet lists all or a single
        configuration type(s)

        This function can call the following endpoints:
            Index =  /configuration_types

            Show =   /configuration_types/:id

    .PARAMETER FilterName
        Filter by configuration type name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Define the configuration type by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueConfigurationType

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueConfigurationType -ID 8765309

        Returns the configuration type with the defined id

    .EXAMPLE
        Get-ITGlueConfigurationType -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for configuration types
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationTypes/Get-ITGlueConfigurationType.html

    .LINK
        https://api.itglue.com/developer/#configuration-types-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/configuration_types" }
            'Show'  { $ResourceUri = "/configuration_types/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\ConfigurationTypes\Get-ITGlueConfigurationType.ps1' 133
#Region '.\Public\ConfigurationTypes\New-ITGlueConfigurationType.ps1' -1

function New-ITGlueConfigurationType {
<#
    .SYNOPSIS
        Creates a configuration type

    .DESCRIPTION
        The New-ITGlueConfigurationType cmdlet creates a new configuration type

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueConfigurationType -Data $JsonObject

        Creates a new configuration type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationTypes/New-ITGlueConfigurationType.html

    .LINK
        https://api.itglue.com/developer/#configuration-types-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/configuration_types'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationTypes\New-ITGlueConfigurationType.ps1' 63
#Region '.\Public\ConfigurationTypes\Set-ITGlueConfigurationType.ps1' -1

function Set-ITGlueConfigurationType {
<#
    .SYNOPSIS
        Updates a configuration type

    .DESCRIPTION
        The Set-ITGlueConfigurationType cmdlet updates a configuration type
        in your account

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Define the configuration type by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueConfigurationType -id 8675309 -Data $JsonObject

        Update the defined configuration type with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationTypes/Set-ITGlueConfigurationType.html

    .LINK
        https://api.itglue.com/developer/#configuration-types-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/configuration_types/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ConfigurationTypes\Set-ITGlueConfigurationType.ps1' 73
#Region '.\Public\Contacts\Get-ITGlueContact.ps1' -1

function Get-ITGlueContact {
<#
    .SYNOPSIS
        List or show all contacts

    .DESCRIPTION
        The Get-ITGlueContact cmdlet lists all or a single contact(s)
        from your account or a defined organization

        This function can call the following endpoints:
            Index = /contacts
                    /organizations/:organization_id/relationships/contacts

            Show =   /contacts/:id
                    /organizations/:organization_id/relationships/contacts/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by contact id

    .PARAMETER FilterFirstName
        Filter by contact first name

    .PARAMETER FilterLastName
        Filter by contact last name

    .PARAMETER FilterTitle
        Filter by contact title

    .PARAMETER FilterContactTypeID
        Filter by contact type id

    .PARAMETER FilterImportant
        Filter by if contact is important

        A users important field in ITGlue can sometimes
        be null which will cause this parameter to return
        incomplete information

    .PARAMETER FilterPrimaryEmail
        Filter by contact primary email address

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a PSA id

        This must be accompanied by the filter for FilterPsaIntegrationType

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'first_name', 'last_name', 'id', 'created_at', 'updated_at',
        '-first_name', '-last_name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Define a contact id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, distinct_remote_contacts, group_resource_accesses,
        location, passwords, resource_fields, tickets, user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        recent_versions, related_items, authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueContact

        Returns the first 50 contacts from your ITGlue account

    .EXAMPLE
        Get-ITGlueContact -OrganizationID 8765309

        Returns the first 50 contacts from the defined organization

    .EXAMPLE
        Get-ITGlueContact -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for contacts
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Get-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet('true', 'false')]
        [string]$FilterImportant,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet(   'first_name', 'last_name', 'id', 'created_at', 'updated_at',
                        '-first_name', '-last_name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources','attachments', 'authorized_users', 'distinct_remote_contacts',
                        'group_resource_accesses', 'location', 'passwords', 'recent_versions',
                        'related_items', 'resource_fields', 'tickets','user_resource_accesses')]
        $Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        if ($PSCmdlet.ParameterSetName -eq 'Index' -or $PSCmdlet.ParameterSetName -eq 'Index_PSA') {

            switch ([bool]$OrganizationID) {
                $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts" }
                $false  { $ResourceUri = "/contacts" }
            }

        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {

            switch ([bool]$OrganizationID) {
                $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts/$ID" }
                $false  { $ResourceUri = "/contacts/$ID" }
            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if (($PSCmdlet.ParameterSetName -eq 'Index') -or ($PSCmdlet.ParameterSetName -eq 'Index_PSA')) {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterFirstName)           { $query_params['filter[first_name]']           = $FilterFirstName }
            if ($FilterLastName)            { $query_params['filter[last_name]']            = $FilterLastName }
            if ($FilterTitle)               { $query_params['filter[title]']                = $FilterTitle }
            if ($FilterContactTypeID)       { $query_params['filter[contact_type_id]']      = $FilterContactTypeID }
            if ($FilterImportant)           { $query_params['filter[important]']            = $FilterImportant }
            if ($FilterPrimaryEmail)        { $query_params['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID}
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
            if ($Sort)                      { $query_params['sort']                         = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Index_PSA') {
            if($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Contacts\Get-ITGlueContact.ps1' 270
#Region '.\Public\Contacts\New-ITGlueContact.ps1' -1

function New-ITGlueContact {
<#
    .SYNOPSIS
        Creates one or more contacts

    .DESCRIPTION
        The New-ITGlueContact cmdlet creates one or more contacts
        under the organization specified

        Can also be used create multiple new contacts in bulk

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The organization id to create the contact(s) in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueContact -OrganizationID 8675309 -Data $JsonObject

        Create a new contact in the defined organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/New-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$OrganizationID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts" }
            $false  { $ResourceUri = "/contacts" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Contacts\New-ITGlueContact.ps1' 78
#Region '.\Public\Contacts\Remove-ITGlueContact.ps1' -1

function Remove-ITGlueContact {
<#
    .SYNOPSIS
        Deletes one or more contacts

    .DESCRIPTION
        The Remove-ITGlueContact cmdlet deletes one or more specified contacts

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by contact id

    .PARAMETER FilterFirstName
        Filter by contact first name

    .PARAMETER FilterLastName
        Filter by contact last name

    .PARAMETER FilterTitle
        Filter by contact title

    .PARAMETER FilterContactTypeID
        Filter by contact type id

    .PARAMETER FilterImportant
        Filter by if contact is important

    .PARAMETER FilterPrimaryEmail
        Filter by contact primary email address

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a PSA id

        This must be accompanied by the filter for FilterPsaIntegrationType

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueContact -Data $JsonObject

        Deletes contacts with the defined in structured
        JSON object

    .EXAMPLE
        Remove-ITGlueContact -FilterID 8675309

        Deletes contacts with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Remove-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [switch]$FilterImportant,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_ByFilter_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts" }
            $false  { $ResourceUri = "/contacts" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like "Bulk_Destroy_*") {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterFirstName)       { $query_params['filter[first_name]']       = $FilterFirstName }
            if ($FilterLastName)        { $query_params['filter[last_name]']        = $FilterLastName }
            if ($FilterTitle)           { $query_params['filter[title]']            = $FilterTitle }
            if ($FilterContactTypeID)   { $query_params['filter[contact_type_id]']  = $FilterContactTypeID }

            if ($FilterImportant -eq $true)         { $query_params['filter[important]'] = '1' }
            elseif ($FilterImportant -eq $false)    { $query_params['filter[important]'] = '0'}

            if ($FilterPrimaryEmail)        { $query_params['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy_ByFilter_PSA') {
            if($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Contacts\Remove-ITGlueContact.ps1' 182
#Region '.\Public\Contacts\Set-ITGlueContact.ps1' -1

function Set-ITGlueContact {
<#
    .SYNOPSIS
        Updates one or more contacts

    .DESCRIPTION
        The Set-ITGlueContact cmdlet updates the details of one
        or more specified contacts

        Returns 422 Bad Request error if trying to update an externally synced record

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update = /contacts/:id
                    /organizations/:organization_id/relationships/contacts/:id

            Bulk_Update =  /contacts

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        Define a contact id

    .PARAMETER FilterID
        Filter by contact id

    .PARAMETER FilterFirstName
        Filter by contact first name

    .PARAMETER FilterLastName
        Filter by contact last name

    .PARAMETER FilterTitle
        Filter by contact title

    .PARAMETER FilterContactTypeID
        Filter by contact type id

    .PARAMETER FilterImportant
        Filter by if contact is important

    .PARAMETER FilterPrimaryEmail
        Filter by contact primary email address

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a PSA id

        This must be accompanied by the filter for FilterPsaIntegrationType

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueContact -id 8675309 -Data $JsonObject

        Updates the defined contact with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Contacts/Set-ITGlueContact.html

    .LINK
        https://api.itglue.com/developer/#contacts-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterFirstName,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterLastName,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterTitle,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [int64]$FilterContactTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [switch]$FilterImportant,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterPrimaryEmail,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter')]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_ByFilter_PSA', Mandatory = $true)]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/contacts/$ID" }
                    $false  { $ResourceUri = "/contacts/$ID" }
                }

            }
            'Bulk_Update'   { $ResourceUri = "/contacts" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like "Bulk_Update_*") {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterFirstName)       { $query_params['filter[first_name]']       = $FilterFirstName }
            if ($FilterLastName)        { $query_params['filter[last_name]']        = $FilterLastName }
            if ($FilterTitle)           { $query_params['filter[title]']            = $FilterTitle }
            if ($FilterContactTypeID)   { $query_params['filter[contact_type_id]']  = $FilterContactTypeID }

            if ($FilterImportant -eq $true)         { $query_params['filter[important]'] = '1' }
            elseif ($FilterImportant -eq $false)    { $query_params['filter[important]'] = '0'}

            if ($FilterPrimaryEmail)        { $query_params['filter[primary_email]']        = $FilterPrimaryEmail }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update_ByFilter_PSA') {
            if($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Contacts\Set-ITGlueContact.ps1' 202
#Region '.\Public\ContactTypes\Get-ITGlueContactType.ps1' -1

function Get-ITGlueContactType {
<#
    .SYNOPSIS
        List or show all contact types

    .DESCRIPTION
        The Get-ITGlueContactType cmdlet returns a list of contacts types
        in your account

        This function can call the following endpoints:
            Index = /contact_types

            Show =  /contact_types/:id

    .PARAMETER FilterName
        Filter by a contact type name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Define a contact type id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueContactType

        Returns the first 50 contact types from your ITGlue account

    .EXAMPLE
        Get-ITGlueContactType -id 8765309

        Returns the details of the defined contact type

    .EXAMPLE
        Get-ITGlueContactType -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for contacts types
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/Get-ITGlueContactType.html

    .LINK
        https://api.itglue.com/developer/#contact-types-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/contact_types" }
            'Show'  { $ResourceUri = "/contact_types/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\ContactTypes\Get-ITGlueContactType.ps1' 133
#Region '.\Public\ContactTypes\New-ITGlueContactType.ps1' -1

function New-ITGlueContactType {
<#
    .SYNOPSIS
        Create a new contact type

    .DESCRIPTION
        The New-ITGlueContactType cmdlet creates a new contact type in
        your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueContactType -Data $JsonObject

        Creates a new contact type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/New-ITGlueContactType.html

    .LINK
        https://api.itglue.com/developer/#contact-types-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/contact_types'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ContactTypes\New-ITGlueContactType.ps1' 64
#Region '.\Public\ContactTypes\Set-ITGlueContactType.ps1' -1

function Set-ITGlueContactType {
<#
    .SYNOPSIS
        Updates a contact type

    .DESCRIPTION
        The Set-ITGlueContactType cmdlet updates a contact type
        in your account

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Define the contact type id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueContactType -id 8675309 -Data $JsonObject

        Update the defined contact type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ContactTypes/Set-ITGlueContactType.html

    .LINK
        https://api.itglue.com/developer/#contact-types-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/contact_types/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\ContactTypes\Set-ITGlueContactType.ps1' 72
#Region '.\Public\Countries\Get-ITGlueCountry.ps1' -1

function Get-ITGlueCountry {
<#
    .SYNOPSIS
        Returns a list of supported countries

    .DESCRIPTION
        The Get-ITGlueCountry cmdlet returns a list of supported countries
        as well or details of one of the supported countries

        This function can call the following endpoints:
            Index = /countries

            Show =  /countries/:id

    .PARAMETER FilterName
        Filter by country name

    .PARAMETER FilterISO
        Filter by country iso abbreviation

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a country by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueCountry

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueCountry -ID 8765309

        Returns the country details with the defined id

    .EXAMPLE
        Get-ITGlueCountry -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for countries
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Countires/Get-ITGlueCountry.html

    .LINK
        https://api.itglue.com/developer/#countries-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterISO,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/countries" }
            'Show'  { $ResourceUri = "/countries/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($FilterISO)     { $query_params['filter[iso]']  = $FilterISO }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params["page[number]"] = $PageNumber }
            if ($PageSize)      { $query_params["page[size]"]   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Countries\Get-ITGlueCountry.ps1' 139
#Region '.\Public\Documents\Set-ITGlueDocument.ps1' -1

function Set-ITGlueDocument {
<#
    .SYNOPSIS
        Updates one or more documents

    .DESCRIPTION
        The Set-ITGlueDocument cmdlet updates one or more existing documents

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update =    /documents/:id
                        /organizations/:organization_id/relationships/documents/:id

            Bulk_Update =  /documents

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER ID
        The document id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueDocument -id 8675309 -Data $JsonObject

        Updates the defined document with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Documents/Set-ITGlueDocument.html

    .LINK
        https://api.itglue.com/developer/#documents-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/documents/$ID" }
                    $false  { $ResourceUri = "/documents/$ID" }
                }

            }
            'Bulk_Update'   { $ResourceUri = "/documents" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }


    }

    end {}

}
#EndRegion '.\Public\Documents\Set-ITGlueDocument.ps1' 98
#Region '.\Public\Domains\Get-ITGlueDomain.ps1' -1

function Get-ITGlueDomain {
<#
    .SYNOPSIS
        List or show all domains

    .DESCRIPTION
        The Get-ITGlueDomain cmdlet list or show all domains in
        your account or from a specified organization

        This function can call the following endpoints:
            Index = /domains
                    /organizations/:organization_id/relationships/domains

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER FilterID
        The domain id to filter for

    .PARAMETER FilterOrganizationID
        The organization id to filter for

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at'
        '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values:
        'passwords', 'attachments', 'user_resource_accesses', 'group_resource_accesses'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueDomain

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueDomain -OrganizationID 12345

        Returns the domains from the defined organization id

    .EXAMPLE
        Get-ITGlueDomain -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for domains
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Domains/Get-ITGlueDomain.html

    .LINK
        https://api.itglue.com/developer/#domains-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('passwords', 'attachments', 'user_resource_accesses', 'group_resource_accesses')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/domains" }
            $false  { $ResourceUri = "/domains" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']  = $FilterOrganizationID }
            if ($Sort)                  { $query_params['sort']                     = $Sort }
            if ($PageNumber)            { $query_params['page[number]']             = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']               = $PageSize}
            if ($Include)               { $query_params['include']                  = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Domains\Get-ITGlueDomain.ps1' 150
#Region '.\Public\Expirations\Get-ITGlueExpiration.ps1' -1

function Get-ITGlueExpiration {
<#
    .SYNOPSIS
        List or show all expirations

    .DESCRIPTION
        The Get-ITGlueExpiration cmdlet returns a list of expirations
        for all organizations or for a specified organization

        This function can call the following endpoints:
            Index = /expirations
                    /organizations/:organization_id/relationships/expirations

            Show =  /expirations/:id
                    /organizations/:organization_id/relationships/expirations/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by expiration id

    .PARAMETER FilterResourceID
        Filter by a resource id

    .PARAMETER FilterResourceName
        Filter by a resource name

    .PARAMETER FilterResourceTypeName
        Filter by a resource type name

    .PARAMETER FilterDescription
        Filter expiration description

    .PARAMETER FilterExpirationDate
        Filter expiration date

    .PARAMETER FilterOrganizationID
        Filter by organization name

    .PARAMETER FilterRange
        Filter by expiration range

        To filter on a specific range, supply two comma-separated values
        Example:
            "2, 10" is filtering for all that are greater than or equal to 2
            and less than or equal to 10

        Or, an asterisk ( * ) can filter on values either greater than or equal to
            Example:
                "2, *", or less than or equal to ("*, 10")

    .PARAMETER FilterRangeExpirationDate
        Filter by expiration date range

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'id', 'organization_id', 'expiration_date', 'created_at', 'updated_at',
        '-id', '-organization_id', '-expiration_date', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        A valid expiration ID

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueExpiration

        Returns the first 50 results from your ITGlue account

    .EXAMPLE
        Get-ITGlueExpiration -ID 8765309

        Returns the expiration with the defined id

    .EXAMPLE
        Get-ITGlueExpiration -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for expirations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Expirations/Get-ITGlueExpiration.html

    .LINK
        https://api.itglue.com/developer/#expirations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterResourceID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceTypeName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterDescription,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterExpirationDate,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterRange,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterRangeExpirationDate,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'id', 'organization_id', 'expiration_date', 'created_at', 'updated_at',
                        '-id', '-organization_id', '-expiration_date', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' {

                if ($OrganizationID) {
                    $ResourceUri = "/organizations/$OrganizationID/relationships/expirations"
                }
                else{$ResourceUri = "/expirations"}

            }
            'Show'  {

                if ($OrganizationID) {
                    $ResourceUri = "/organizations/$OrganizationID/relationships/expirations/$ID"
                }
                else{$ResourceUri = "/expirations/$ID"}

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $query_params['filter[id]']                   = $FilterID }
            if ($FilterResourceID)      { $query_params['filter[resource_id]']          = $FilterResourceID }
            if ($FilterResourceName)    { $query_params['filter[resource_name]']        = $FilterResourceName }
            if ($FilterResourceTypeName) { $query_params['filter[resource_type_name]']   = $FilterResourceTypeName }
            if ($FilterDescription)     { $query_params['filter[description]']          = $FilterDescription }
            if ($FilterExpirationDate)  { $query_params['filter[expiration_date]']      = $FilterExpirationDate }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterRange)           { $query_params['filter[range]']                = $FilterRange }
            if ($Sort)                  { $query_params['sort']                         = $Sort }
            if ($PageNumber)            { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']                   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Expirations\Get-ITGlueExpiration.ps1' 220
#Region '.\Public\Exports\Get-ITGlueExport.ps1' -1

function Get-ITGlueExport {
<#
    .SYNOPSIS
        List or show all exports

    .DESCRIPTION
        The Get-ITGlueExport cmdlet returns a list of exports
        or the details of a single export in your account

        This function can call the following endpoints:
            Index = /exports

            Show =  /exports/:id

    .PARAMETER FilterID
        Filter by a export id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at',
        '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a export by id

    .PARAMETER Include
        Include additional information

        Allowed values:
        '.'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueExport

        Returns the first 50 exports from your ITGlue account

    .EXAMPLE
        Get-ITGlueExport -ID 8765309

        Returns the export with the defined id

    .EXAMPLE
        Get-ITGlueExport -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for exports
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Exports/Get-ITGlueExport.html

    .LINK
        https://api.itglue.com/developer/#exports-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('.')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/exports" }
            'Show'  { $ResourceUri = "/exports/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']   = $FilterID }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {
            if ($Include) { $query_params['include'] = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Exports\Get-ITGlueExport.ps1' 147
#Region '.\Public\Exports\New-ITGlueExport.ps1' -1

function New-ITGlueExport {
<#
    .SYNOPSIS
        Creates a new export

    .DESCRIPTION
        The New-ITGlueExport cmdlet creates a new export
        in your account

        The new export will be for a single organization if organization_id is specified;
        otherwise the new export will be for all organizations of the current account

        The actual export attachment will be created later after the export record is created
        Please check back using show endpoint, you will see a downloadable url when the record shows done

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

        If not defined then the entire ITGlue account is exported

    .PARAMETER IncludeLogs
        Define if logs should be included in the export

    .PARAMETER ZipPassword
        Password protect the export

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueExport -Data $JsonObject

        Creates a new export with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Exports/New-ITGlueExport.html

    .LINK
        https://api.itglue.com/developer/#exports-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create',SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Custom_Create')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Custom_Create')]
        [switch]$IncludeLogs,

        [Parameter(ParameterSetName = 'Custom_Create')]
        [ValidateNotNullOrEmpty()]
        [string]$ZipPassword,

        [Parameter(ParameterSetName = 'Create',Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/exports'

        if ($PSCmdlet.ParameterSetName -eq 'Custom_Create') {

            if ($OrganizationID -eq 0) {
                $ConfirmPreference = 'low'
                Write-Warning 'Exporting entire ITGlue account'
            }

            $Data = @{
                type = 'exports'
                attributes = @{
                    'organization-id'   = if ($OrganizationID) {$OrganizationID}else{$null}
                    'include-logs'      = if ($IncludeLogs) {'True'}else{$null}
                    'zip-password'      = if ($ZipPassword) {$ZipPassword}else{$null}
                }
            }

        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\Exports\New-ITGlueExport.ps1' 109
#Region '.\Public\Exports\Remove-ITGlueExport.ps1' -1

function Remove-ITGlueExport {
<#
    .SYNOPSIS
        Deletes an export

    .DESCRIPTION
        The Remove-ITGlueExport cmdlet deletes an export

    .PARAMETER ID
        ID of export to delete

    .EXAMPLE
        Remove-ITGlueExport -ID 8675309

        Deletes the export with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Exports/Remove-ITGlueExport.html

    .LINK
        https://api.itglue.com/developer/#exports-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/exports/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\Exports\Remove-ITGlueExport.ps1' 57
#Region '.\Public\FlexibleAssetFields\Get-ITGlueFlexibleAssetField.ps1' -1

function Get-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        List or show all flexible assets fields

    .DESCRIPTION
        The Get-ITGlueFlexibleAssetField cmdlet lists or shows all flexible asset fields
        for a particular flexible asset type

        This function can call the following endpoints:
            Index = /flexible_asset_types/:flexible_asset_type_id/relationships/flexible_asset_fields

            Show =  /flexible_asset_fields/:id
                    /flexible_asset_types/:flexible_asset_type_id/relationships/flexible_asset_fields/:id

    .PARAMETER FlexibleAssetTypeID
        A valid Flexible asset Id in your Account

    .PARAMETER FilterID
        Filter by a flexible asset field id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at', 'updated_at',
        '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        A valid Flexible asset type Id in your Account

    .PARAMETER Include
        Include specified assets

        Allowed values:
        remote_asset_field

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueFlexibleAssetField -FlexibleAssetTypeID 12345

        Returns all the fields in a flexible asset with the defined id

    .EXAMPLE
        Get-ITGlueFlexibleAssetField -ID 8765309

        Returns single field in a flexible asset with the defined id

    .EXAMPLE
        Get-ITGlueFlexibleAssetField -FlexibleAssetTypeID 12345 -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for flexible asset fields
        from the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Get-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$FlexibleAssetTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'created_at', 'updated_at',
                        '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('remote_asset_field')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields" }
            'Show'  {

                switch ([bool]$FlexibleAssetTypeID) {
                    $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields/$ID" }
                    $false  { $ResourceUri = "/flexible_asset_fields/$ID" }
                }

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']   = $FilterID }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
            if ($Include)       { $query_params['include']      = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetFields\Get-ITGlueFlexibleAssetField.ps1' 159
#Region '.\Public\FlexibleAssetFields\New-ITGlueFlexibleAssetField.ps1' -1

function New-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Creates one or more flexible asset fields

    .DESCRIPTION
        The New-ITGlueFlexibleAssetField cmdlet creates one or more
        flexible asset field for a particular flexible asset type

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER FlexibleAssetTypeID
        The flexible asset type id to create a new field in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueFlexibleAssetField -FlexibleAssetTypeID 8675309 -Data $JsonObject

        Creates a new flexible asset field for the defined id with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/New-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$FlexibleAssetTypeID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$FlexibleAssetTypeID) {
            $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields" }
            $false  { $ResourceUri = "/flexible_asset_fields" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetFields\New-ITGlueFlexibleAssetField.ps1' 74
#Region '.\Public\FlexibleAssetFields\Remove-ITGlueFlexibleAssetField.ps1' -1

function Remove-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Delete a flexible asset field

    .DESCRIPTION
        The Remove-ITGlueFlexibleAssetField cmdlet deletes a flexible asset field

        Note that this action will cause data loss if the field is already in use

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer


    .PARAMETER ID
        Id of a flexible asset field

    .PARAMETER FlexibleAssetTypeID
        A flexible asset type Id in your Account

    .EXAMPLE
        Remove-ITGlueFlexibleAssetField -id 8675309

        Deletes a defined flexible asset field and any data associated to that
        field

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Remove-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter()]
        [int64]$FlexibleAssetTypeID,

        [Parameter(Mandatory = $true)]
        [int64]$ID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$FlexibleAssetTypeID) {
            $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields/$ID" }
            $false  { $ResourceUri = "/flexible_asset_fields/$ID" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetFields\Remove-ITGlueFlexibleAssetField.ps1' 73
#Region '.\Public\FlexibleAssetFields\Set-ITGlueFlexibleAssetField.ps1' -1

function Set-ITGlueFlexibleAssetField {
<#
    .SYNOPSIS
        Updates one or more flexible asset fields

    .DESCRIPTION
        The Set-ITGlueFlexibleAssetField cmdlet updates the details of one
        or more existing flexible asset fields

        Any attributes you don't specify will remain unchanged

        Can also be used to bulk update flexible asset fields

        Returns 422 error if trying to change the kind attribute of fields that
        are already in use

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER FlexibleAssetTypeID
        A valid Flexible asset Id in your Account

    .PARAMETER ID
        Id of a flexible asset field

    .PARAMETER FilterID
        Filter by a flexible asset field id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueFlexibleAssetField -id 8675309 -Data $JsonObject

        Updates a defined flexible asset field with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetFields/Set-ITGlueFlexibleAssetField.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-fields-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$FlexibleAssetTypeID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Update'   { $ResourceUri = "/flexible_asset_fields" }
            'Update'        {

                switch ([bool]$FlexibleAssetTypeID) {
                    $true   { $ResourceUri = "/flexible_asset_types/$FlexibleAssetTypeID/relationships/flexible_asset_fields/$ID"}
                    $false  { $ResourceUri = "/flexible_asset_fields/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update') {
            if ($FilterID) { $query_params['filter[id]'] = $FilterID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetFields\Set-ITGlueFlexibleAssetField.ps1' 114
#Region '.\Public\FlexibleAssets\Get-ITGlueFlexibleAsset.ps1' -1

function Get-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        List or show all flexible assets

    .DESCRIPTION
        The Get-ITGlueFlexibleAsset cmdlet returns a list of flexible assets or
        the details of a single flexible assets based on the unique ID of the
        flexible asset type

        This function can call the following endpoints:
            Index = /flexible_assets

            Show =  /flexible_assets/:id

    .PARAMETER FilterFlexibleAssetTypeID
        Filter by a flexible asset id

        This is the flexible assets id number you see in the URL under an organizations

    .PARAMETER FilterName
        Filter by a flexible asset name

    .PARAMETER FilterOrganizationID
        Filter by a organization id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at',
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, distinct_remote_assets, group_resource_accesses
        passwords, user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        authorized_users, recent_versions, related_items

    .PARAMETER ID
        Get a flexible asset id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309

        Returns the first 50 results for the defined flexible asset

    .EXAMPLE
        Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID 8765309 -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for the defined
        flexible asset

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Get-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', Mandatory = $true)]
        [int64]$FilterFlexibleAssetTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources', 'attachments', 'authorized_users', 'distinct_remote_assets',
                        'group_resource_accesses', 'passwords', 'recent_versions','related_items',
                        'user_resource_accesses'
        )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/flexible_assets" }
            'Show'  { $ResourceUri = "/flexible_assets/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterFlexibleAssetTypeID) { $query_params['filter[flexible-asset-type-id]']   = $FilterFlexibleAssetTypeID }
            if ($FilterName)                { $query_params['filter[name]']                     = $FilterName }
            if ($FilterOrganizationID)      { $query_params['filter[organization-id]']          = $FilterOrganizationID }
            if ($Sort)                      { $query_params['sort']                             = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                     = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                       = $PageSize }
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssets\Get-ITGlueFlexibleAsset.ps1' 169
#Region '.\Public\FlexibleAssets\New-ITGlueFlexibleAsset.ps1' -1

function New-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        Creates one or more flexible assets

    .DESCRIPTION
        The New-ITGlueFlexibleAsset cmdlet creates one or more
        flexible assets

        If there are any required fields in the flexible asset type,
        they will need to be included in the request

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The organization id to create the flexible asset in

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueFlexibleAsset -OrganizationID 8675309 -Data $JsonObject

        Creates a new flexible asset in the defined organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/New-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Create', Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Create', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Create'   { $ResourceUri = "/organizations/$OrganizationID/relationships/flexible_assets" }
            'Create'        { $ResourceUri = '/flexible_assets' }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssets\New-ITGlueFlexibleAsset.ps1' 78
#Region '.\Public\FlexibleAssets\Remove-ITGlueFlexibleAsset.ps1' -1

function Remove-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        Deletes one or more a flexible assets

    .DESCRIPTION
        The Remove-ITGlueFlexibleAsset cmdlet destroys multiple or a single
        flexible asset

    .PARAMETER ID
        The flexible asset id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueFlexibleAsset -id 8675309

        Deletes the defined flexible asset

    .EXAMPLE
        Remove-ITGlueFlexibleAsset -Data $JsonObject

        Deletes flexible asset defined in the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Remove-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Destroy'  { $ResourceUri = "/flexible_assets" }
            'Destroy'       { $ResourceUri = "/flexible_assets/$ID" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssets\Remove-ITGlueFlexibleAsset.ps1' 75
#Region '.\Public\FlexibleAssets\Set-ITGlueFlexibleAsset.ps1' -1

function Set-ITGlueFlexibleAsset {
<#
    .SYNOPSIS
        Updates one or more flexible assets

    .DESCRIPTION
        The Set-ITGlueFlexibleAsset cmdlet updates one or more flexible assets

        Any traits you don't specify will be deleted
        Passing a null value will also delete a trait's value

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        The flexible asset id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueFlexibleAsset -id 8675309 -Data $JsonObject

        Updates a defined flexible asset with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssets/Set-ITGlueFlexibleAsset.html

    .LINK
        https://api.itglue.com/developer/#flexible-assets-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Update'   { $ResourceUri = "/flexible_assets" }
            'Update'        { $ResourceUri = "/flexible_assets/$ID" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssets\Set-ITGlueFlexibleAsset.ps1' 76
#Region '.\Public\FlexibleAssetTypes\Get-ITGlueFlexibleAssetType.ps1' -1

function Get-ITGlueFlexibleAssetType {
<#
    .SYNOPSIS
        List or show all flexible asset types

    .DESCRIPTION
        The Get-ITGlueFlexibleAssetType cmdlet returns details on a flexible asset type
        or a list of flexible asset types in your account

        This function can call the following endpoints:
            Index = /flexible_asset_types

            Show =  /flexible_asset_types/:id

    .PARAMETER FilterID
        Filter by a flexible asset id

    .PARAMETER FilterName
        Filter by a flexible asset name

    .PARAMETER FilterIcon
        Filter by a flexible asset icon

    .PARAMETER FilterEnabled
        Filter if a flexible asset is enabled

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include specified assets

        Allowed values:
        'flexible_asset_fields'

    .PARAMETER ID
        A valid flexible asset id in your account

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueFlexibleAssetType

        Returns the first 50 flexible asset results from your ITGlue account

    .EXAMPLE
        Get-ITGlueFlexibleAssetType -ID 8765309

        Returns the defined flexible asset with the defined id

    .EXAMPLE
        Get-ITGlueFlexibleAssetType -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for flexible assets
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Get-ITGlueFlexibleAssetType.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-types-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterIcon,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('true', 'false')]
        [string]$FilterEnabled,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('flexible_asset_fields')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/flexible_asset_types" }
            'Show'  { $ResourceUri = "/flexible_asset_types/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']       = $FilterID }
            if ($FilterName)    { $query_params['filter[name]']     = $FilterName }
            if ($FilterIcon)    { $query_params['filter[icon]']     = $FilterIcon }
            if ($FilterEnabled) { $query_params['filter[enabled]']  = $FilterEnabled }
            if ($Sort)          { $query_params['sort']             = $Sort }
            if ($PageNumber)    { $query_params['page[number]']     = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']       = $PageSize }
        }

        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetTypes\Get-ITGlueFlexibleAssetType.ps1' 167
#Region '.\Public\FlexibleAssetTypes\New-ITGlueFlexibleAssetType.ps1' -1

function New-ITGlueFlexibleAssetType {
<#
    .SYNOPSIS
        Creates one or more flexible asset types

    .DESCRIPTION
        The New-ITGlueFlexibleAssetType cmdlet creates one or
        more flexible asset types

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueFlexibleAssetType -Data $JsonObject

        Creates a new flexible asset type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/New-ITGlueFlexibleAssetType.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-types-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/flexible_asset_types'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetTypes\New-ITGlueFlexibleAssetType.ps1' 64
#Region '.\Public\FlexibleAssetTypes\Set-ITGlueFlexibleAssetType.ps1' -1

function Set-ITGlueFlexibleAssetType {
<#
    .SYNOPSIS
        Updates a flexible asset type

    .DESCRIPTION
        The Set-ITGlueFlexibleAssetType cmdlet updates the details of an
        existing flexible asset type in your account

        Any attributes you don't specify will remain unchanged

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        A valid flexible asset id in your account

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueFlexibleAssetType -id 8765309 -Data $JsonObject

        Update a flexible asset type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/FlexibleAssetTypes/Set-ITGlueFlexibleAssetType.html

    .LINK
        https://api.itglue.com/developer/#flexible-asset-types-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/flexible_asset_types/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\FlexibleAssetTypes\Set-ITGlueFlexibleAssetType.ps1' 72
#Region '.\Public\Groups\Get-ITGlueGroup.ps1' -1

function Get-ITGlueGroup {
<#
    .SYNOPSIS
        List or show all groups

    .DESCRIPTION
        The Get-ITGlueGroup cmdlet returns a list of groups or the
        details of a single group in your account

        This function can call the following endpoints:
            Index = /groups

            Show =  /groups/:id

    .PARAMETER FilterName
        Filter by a group name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at',
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a group by id

    .PARAMETER Include
        Include other items with groups

        Allowed values:
        'users'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueGroup

        Returns the first 50 group results from your ITGlue account

    .EXAMPLE
        Get-ITGlueGroup -ID 8765309

        Returns the group with the defined id

    .EXAMPLE
        Get-ITGlueGroup -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for groups
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Groups/Get-ITGlueGroup.html

    .LINK
        https://api.itglue.com/developer/#groups-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('users')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/groups" }
            'Show'  { $ResourceUri = "/groups/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #Shared Parameters
        if ($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Groups\Get-ITGlueGroup.ps1' 147
#Region '.\Public\Locations\Get-ITGlueLocation.ps1' -1

function Get-ITGlueLocation {
<#
    .SYNOPSIS
        List or show all location

    .DESCRIPTION
        The Get-ITGlueLocation cmdlet returns a list of locations for
        all organizations or for a specified organization

        This function can call the following endpoints:
            Index = /locations
                    /organizations/:$OrganizationID/relationships/locations

            Show =  /locations/:id
                    /organizations/:id/relationships/locations/:id

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER FilterID
        Filter by a location id

    .PARAMETER FilterName
        Filter by a location name

    .PARAMETER FilterCity
        Filter by a location city

    .PARAMETER FilterRegionID
        Filter by a location region id

    .PARAMETER FilterCountryID
        Filter by a location country id

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a psa integration id

    .PARAMETER FilterPsaIntegrationType
        Filter by a psa integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a location by id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, group_resource_accesses,
        passwords ,user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        recent_versions ,related_items ,authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueLocation

        Returns the first 50 location results from your ITGlue account

    .EXAMPLE
        Get-ITGlueLocation -ID 8765309

        Returns the location with the defined id

    .EXAMPLE
        Get-ITGlueLocation -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for locations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Get-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'adapters_resources', 'attachments', 'group_resource_accesses', 'passwords',
                        'user_resource_accesses', 'recent_versions', 'related_items', 'authorized_users'
        )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Index*'   {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations" }
                    $false  { $ResourceUri = "/locations" }
                }

            }
            'Show'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
                    $false  { $ResourceUri = "/locations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if (($PSCmdlet.ParameterSetName -like 'Index*')) {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $query_params['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $query_params['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $query_params['filter[country_id]']            = $FilterCountryID }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
            if ($Sort)                      { $query_params['sort']                         = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Index_PSA') {
            $query_params['filter[psa_id]'] = $FilterPsaID
        }

        if($Include) {
            $query_params['include'] = $Include
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Locations\Get-ITGlueLocation.ps1' 250
#Region '.\Public\Locations\New-ITGlueLocation.ps1' -1

function New-ITGlueLocation {
<#
    .SYNOPSIS
        Creates one or more locations

    .DESCRIPTION
        The New-ITGlueLocation cmdlet creates one or more
        locations for specified organization

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueLocation -$OrganizationID 8675309 -Data $JsonObject

        Creates a new location under the defined organization with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/New-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations" }
            $false  { $ResourceUri = "/locations" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Locations\New-ITGlueLocation.ps1' 74
#Region '.\Public\Locations\Remove-ITGlueLocation.ps1' -1

function Remove-ITGlueLocation {
<#
    .SYNOPSIS
        Deletes one or more locations

    .DESCRIPTION
        The Set-ITGlueLocation cmdlet deletes one or more
        specified locations

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER ID
        Location id

    .PARAMETER FilterID
        Filter by a location id

    .PARAMETER FilterName
        Filter by a location name

    .PARAMETER FilterCity
        Filter by a location city

    .PARAMETER FilterRegionID
        Filter by a location region id

    .PARAMETER FilterCountryID
        Filter by a location country id

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a psa integration id

    .PARAMETER FilterPsaIntegrationType
        Filter by a psa integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueLocation -OrganizationID 123456 -ID 8765309 -Data $JsonObject

        Removes the defined location from the defined organization with the specified JSON object

    .EXAMPLE
        Remove-ITGlueLocation -Data $JsonObject

        Removes location(s) with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Remove-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
            $false  { $ResourceUri = "/locations" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $query_params['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $query_params['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $query_params['filter[country_id]']           = $FilterCountryID }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy_PSA') {
            $query_params['filter[psa_id]'] = $FilterPsaID
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Locations\Remove-ITGlueLocation.ps1' 168
#Region '.\Public\Locations\Set-ITGlueLocation.ps1' -1

function Set-ITGlueLocation {
<#
    .SYNOPSIS
        Updates one or more a locations

    .DESCRIPTION
        The Set-ITGlueLocation cmdlet updates the details of
        an existing location or locations

        Any attributes you don't specify will remain unchanged

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Get a location by id

    .PARAMETER OrganizationID
        The valid organization id in your account

    .PARAMETER FilterID
        Filter by a location id

    .PARAMETER FilterName
        Filter by a location name

    .PARAMETER FilterCity
        Filter by a location city

    .PARAMETER FilterRegionID
        Filter by a location region id

    .PARAMETER FilterCountryID
        Filter by a location country id

    .PARAMETER FilterOrganizationID
        Filter by an organization ID

    .PARAMETER FilterPsaID
        Filter by a psa integration id

    .PARAMETER FilterPsaIntegrationType
        Filter by a psa integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueLocation -id 8765309 -Data $JsonObject

        Updates the defined location with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Locations/Set-ITGlueLocation.html

    .LINK
        https://api.itglue.com/developer/#locations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterCity,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterRegionID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterCountryID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        [ValidateSet('manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Bulk_Update*'  { $ResourceUri = "/locations" }
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/locations/$ID" }
                    $false  { $ResourceUri = "/locations/$ID" }
                }

            }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterCity)                { $query_params['filter[city]']                 = $FilterCity }
            if ($FilterRegionID)            { $query_params['filter[region_id]']            = $FilterRegionID }
            if ($FilterCountryID)           { $query_params['filter[country_id]']            = $FilterCountryID }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPsaIntegrationType)  { $query_params['filter[psa_integration_type]'] = $FilterPsaIntegrationType }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update_PSA') {
            $query_params['filter[psa_id]'] = $FilterPsaID
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Locations\Set-ITGlueLocation.ps1' 171
#Region '.\Public\Logs\Get-ITGlueLog.ps1' -1

function Get-ITGlueLog {
<#
    .SYNOPSIS
        Get all activity logs of the account for the most recent 30 days

    .DESCRIPTION
        The Get-ITGlueLog cmdlet gets all activity logs of the account for
        the most recent 30 days

        IMPORTANT - This endpoint can ONLY get logs from the past 30 days!

        This endpoint is limited to 5 pages of results. If more results are desired,
        setting a larger page [size] will increase the number of results per page

        To iterate over even more results, use filter [created_at] (with created_at Sort)
        to fetch a subset of results based on timestamp, then use the last timestamp
        in the last page the start date in the filter for the next request

    .PARAMETER FilterCreatedAt
        Filter logs by a UTC start & end date

        Use `*` for unspecified start_date` or `end_date

        The specified string must be a date range and comma-separated as start_date, end_date

        Example:
        2024-09-23, 2024-09-27

        Date ranges longer than a week may be disallowed for performance reasons

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'created_at','-created_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

        This endpoint is limited to 5 pages of results

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueLog

        Pulls the first 50 activity logs from the last 30 days with data
        being Sorted newest to oldest

    .EXAMPLE
        Get-ITGlueLog -sort -created_at

        Pulls the first 50 activity logs from the last 30 days with data
        being Sorted oldest to newest

    .EXAMPLE
        Get-ITGlueLog -PageNumber 2

        Pulls the first 50 activity logs starting from page 2 from the last 30 days
        with data being Sorted newest to oldest

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Logs/Get-ITGlueLog.html

    .LINK
        https://api.itglue.com/developer/#logs
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet( 'created_at','-created_at' )]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/logs'

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterCreatedAt)   { $query_params['filter[created_at]']   = $FilterCreatedAt }
            if ($Sort)              { $query_params['sort']                 = $Sort }
            if ($PageNumber)        { $query_params['page[number]']         = $PageNumber }
            if ($PageSize)          { $query_params['page[size]']           = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Logs\Get-ITGlueLog.ps1' 139
#Region '.\Public\Manufacturers\Get-ITGlueManufacturer.ps1' -1

function Get-ITGlueManufacturer {
<#
    .SYNOPSIS
        List or show all manufacturers

    .DESCRIPTION
        The Get-ITGlueManufacturer cmdlet returns a manufacturer name
        or a list of manufacturers in your account

        This function can call the following endpoints:
            Index = /manufacturers

            Show =  /manufacturers/:id

    .PARAMETER FilterName
        Filter by a manufacturers name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a manufacturer by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueManufacturer

        Returns the first 50 manufacturer results from your ITGlue account

    .EXAMPLE
        Get-ITGlueManufacturer -ID 8765309

        Returns the manufacturer with the defined id

    .EXAMPLE
        Get-ITGlueManufacturer -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for manufacturers
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Get-ITGlueManufacturer.html

    .LINK
        https://api.itglue.com/developer/#manufacturers-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/manufacturers" }
            'Show'  { $ResourceUri = "/manufacturers/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Manufacturers\Get-ITGlueManufacturer.ps1' 133
#Region '.\Public\Manufacturers\New-ITGlueManufacturer.ps1' -1

function New-ITGlueManufacturer {
<#
    .SYNOPSIS
        Create a new manufacturer

    .DESCRIPTION
        The New-ITGlueManufacturer cmdlet creates a new manufacturer

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueManufacturer -Data $JsonObject

        Creates a new manufacturers with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/New-ITGlueManufacturer.html

    .LINK
        https://api.itglue.com/developer/#manufacturers-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/manufacturers/'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}
}
#EndRegion '.\Public\Manufacturers\New-ITGlueManufacturer.ps1' 62
#Region '.\Public\Manufacturers\Set-ITGlueManufacturer.ps1' -1

function Set-ITGlueManufacturer {
<#
    .SYNOPSIS
        Updates a manufacturer

    .DESCRIPTION
        The New-ITGlueManufacturer cmdlet updates a manufacturer

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        The id of the manufacturer to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueManufacturer -id 8765309 -Data $JsonObject

        Updates the defined manufacturer with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Manufacturers/Set-ITGlueManufacturer.html

    .LINK
        https://api.itglue.com/developer/#manufacturers-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/manufacturers/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Manufacturers\Set-ITGlueManufacturer.ps1' 71
#Region '.\Public\Models\Get-ITGlueModel.ps1' -1

function Get-ITGlueModel {
<#
    .SYNOPSIS
        List or show all models

    .DESCRIPTION
        The Get-ITGlueModel cmdlet returns a list of model names for all
        manufacturers or for a specified manufacturer

        This function can call the following endpoints:
            Index = /models

            Show =  /manufacturers/:id/relationships/models

    .PARAMETER ManufacturerID
        Get models under the defined manufacturer id

    .PARAMETER FilterID
        Filter models by id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'id', 'name', 'manufacturer_id', 'created_at', 'updated_at',
        '-id', '-name', '-manufacturer_id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a model by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueModel

        Returns the first 50 model results from your ITGlue account

    .EXAMPLE
        Get-ITGlueModel -ID 8765309

        Returns the model with the defined id

    .EXAMPLE
        Get-ITGlueModel -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for models
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html

    .LINK
        https://api.itglue.com/developer/#models-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$ManufacturerID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'id', 'name', 'manufacturer_id', 'created_at', 'updated_at',
                        '-id', '-name', '-manufacturer_id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' {

                if ($ManufacturerID) {
                    $ResourceUri = "/manufacturers/$ManufacturerID/relationships/models"
                }
                else{$ResourceUri = "/models"}

            }
            'False' {

                if ($ManufacturerID) {
                    $ResourceUri = "/manufacturers/$ManufacturerID/relationships/models/$ID"
                }
                else{$ResourceUri = "/models/$ID"}

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)      { $query_params['filter[id]']   = $FilterID }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Models\Get-ITGlueModel.ps1' 154
#Region '.\Public\Models\New-ITGlueModel.ps1' -1

function New-ITGlueModel {
<#
    .SYNOPSIS
        Creates one or more models

    .DESCRIPTION
        The New-ITGlueModel cmdlet creates one or more models
        in your account or for a particular manufacturer

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ManufacturerID
        The manufacturer id to create the model under

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueModel -Data $JsonObject

        Creates a new model with the specified JSON object

    .EXAMPLE
        New-ITGlueModel -ManufacturerID 8675309 -Data $JsonObject

        Creates a new model associated to the defined model with the
        structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html

    .LINK
        https://api.itglue.com/developer/#models-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$ManufacturerID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$ManufacturerID) {
            $true   { $ResourceUri = "/manufacturers/$ManufacturerID/relationships/models" }
            $false  { $ResourceUri = '/models' }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Models\New-ITGlueModel.ps1' 79
#Region '.\Public\Models\Set-ITGlueModel.ps1' -1

function Set-ITGlueModel {
<#
    .SYNOPSIS
        Updates one or more models

    .DESCRIPTION
        The Set-ITGlueModel cmdlet updates an existing model or
        set of models in your account

        Bulk updates using a nested relationships route are not supported

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ManufacturerID
        Update models under the defined manufacturer id

    .PARAMETER ID
        Update a model by id

    .PARAMETER FilterID
        Filter models by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueModel -id 8675309 -Data $JsonObject

        Updates the defined model with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html

    .LINK
        https://api.itglue.com/developer/#models-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$ManufacturerID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$ManufacturerID) {
                    $true   { $ResourceUri = "/manufacturers/$ManufacturerID/relationships/models/$ID" }
                    $false  { $ResourceUri = "/models/$ID" }
                }

            }
            'Bulk_Update'   { $ResourceUri = "/models" }

        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update') {
            if ($FilterID) { $query_params['filter[id]'] = $FilterID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Models\Set-ITGlueModel.ps1' 110
#Region '.\Public\OperatingSystems\Get-ITGlueOperatingSystem.ps1' -1

function Get-ITGlueOperatingSystem {
<#
    .SYNOPSIS
        List or show all operating systems

    .DESCRIPTION
        The Get-ITGlueOperatingSystem cmdlet returns a list of supported operating systems
        or the details of a defined operating system

        This function can call the following endpoints:
            Index = /operating_systems

            Show =  /operating_systems/:id

    .PARAMETER FilterName
        Filter by operating system name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get an operating system by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOperatingSystem

        Returns the first 50 operating system results from your ITGlue account

    .EXAMPLE
        Get-ITGlueOperatingSystem -ID 8765309

        Returns the operating systems with the defined id

    .EXAMPLE
        Get-ITGlueOperatingSystem -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for operating systems
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OperatingSystems/Get-ITGlueOperatingSystem.html

    .LINK
        https://api.itglue.com/developer/#operating-systems-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/operating_systems" }
            'Show'  { $ResourceUri = "/operating_systems/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\OperatingSystems\Get-ITGlueOperatingSystem.ps1' 133
#Region '.\Public\Organizations\Get-ITGlueOrganization.ps1' -1

function Get-ITGlueOrganization {
<#
    .SYNOPSIS
        List or show all organizations

    .DESCRIPTION
        The Get-ITGlueOrganization cmdlet returns a list of organizations
        or details for a single organization in your account

        This function can call the following endpoints:
            Index = /organizations

            Show =  /organizations/:id

    .PARAMETER FilterID
        Filter by an organization id

    .PARAMETER FilterName
        Filter by an organization name

    .PARAMETER FilterOrganizationTypeID
        Filter by an organization type id

    .PARAMETER FilterOrganizationStatusID
        Filter by an organization status id

    .PARAMETER FilterCreatedAt
        Filter by when an organization created

    .PARAMETER FilterUpdatedAt
        Filter by when an organization updated

    .PARAMETER FilterMyGlueAccountID
        Filter by a MyGlue id

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterGroupID
        Filter by a group id

    .PARAMETER FilterPrimary
        Filter for primary organization

        Allowed values:
        'true', 'false'

    .PARAMETER FilterExcludeID
        Filter to excluded a certain organization id

    .PARAMETER FilterExcludeName
        Filter to excluded a certain organization name

    .PARAMETER FilterExcludeOrganizationTypeID
        Filter to excluded a certain organization type id

    .PARAMETER FilterExcludeOrganizationStatusID
        Filter to excluded a certain organization status id

    .PARAMETER FilterRange
        Filter organizations by range

    .PARAMETER FilterRangeMyGlueAccountID
        Filter MyGLue organization id range

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'updated_at', 'organization_status_name', 'organization_type_name',
        'created_at', 'short_name', 'my_glue_account_id', '-name', '-id', '-updated_at',
        '-organization_status_name', '-organization_type_name', '-created_at',
        '-short_name', '-my_glue_account_id'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get an organization by id

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        adapters_resources, attachments, rmm_companies

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        N/A

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOrganization

        Returns the first 50 organizations results from your ITGlue account

    .EXAMPLE
        Get-ITGlueOrganization -ID 8765309

        Returns the organization with the defined id

    .EXAMPLE
        Get-ITGlueOrganization -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for organizations
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Get-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [string]$FilterRange,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$FilterRangeMyGlueAccountID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateSet( 'name', 'id', 'updated_at', 'organization_status_name', 'organization_type_name', 'created_at', 'short_name', 'my_glue_account_id',
                '-name', '-id', '-updated_at', '-organization_status_name', '-organization_type_name', '-created_at', '-short_name', '-my_glue_account_id')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet( 'adapters_resources', 'attachments', 'rmm_companies' )]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Index_PSA')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Index*'    { $ResourceUri = "/organizations" }
            'Show'      { $ResourceUri = "/organizations/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Index*') {
            if ($FilterID)                          { $query_params['filter[id]']                               = $FilterID }
            if ($FilterName)                        { $query_params['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)          { $query_params['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)        { $query_params['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                   { $query_params['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                   { $query_params['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)             { $query_params['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)          { $query_params['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                     { $query_params['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                     { $query_params['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                   { $query_params['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                 { $query_params['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)   { $query_params['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID) { $query_params['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
            if ($FilterRange)                       { $query_params['filter[range]']                            = $FilterRange }
            if ($FilterRangeMyGlueAccountID)        { $query_params['filter[range][my_glue_account_id]']        = $FilterRangeMyGlueAccountID }
            if ($Sort)                              { $query_params['sort']                                     = $Sort }
            if ($PageNumber)                        { $query_params['page[number]']                             = $PageNumber }
            if ($PageSize)                          { $query_params['page[size]']                               = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Index_PSA') {
            if ($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Organizations\Get-ITGlueOrganization.ps1' 299
#Region '.\Public\Organizations\New-ITGlueOrganization.ps1' -1

function New-ITGlueOrganization {
<#
    .SYNOPSIS
        Create an organization

    .DESCRIPTION
        The New-ITGlueOrganization cmdlet creates an organization

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueOrganization -Data $JsonObject

        Creates a new organization with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/New-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/organizations/'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Organizations\New-ITGlueOrganization.ps1' 63
#Region '.\Public\Organizations\Remove-ITGlueOrganization.ps1' -1

function Remove-ITGlueOrganization {
<#
    .SYNOPSIS
        Deletes one or more organizations

    .DESCRIPTION
        The Remove-ITGlueOrganization cmdlet marks organizations identified by the
        specified organization IDs for deletion

        Because it can be a long procedure to delete organizations,
        removal from the system may not happen immediately

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER FilterID
        Filter by an organization id

    .PARAMETER FilterName
        Filter by an organization name

    .PARAMETER FilterOrganizationTypeID
        Filter by an organization type id

    .PARAMETER FilterOrganizationStatusID
        Filter by an organization status id

    .PARAMETER FilterCreatedAt
        Filter by when an organization created

    .PARAMETER FilterUpdatedAt
        Filter by when an organization updated

    .PARAMETER FilterMyGlueAccountID
        Filter by a MyGlue id

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterGroupID
        Filter by a group id

    .PARAMETER FilterPrimary
        Filter for primary organization

        Allowed values:
        'true', 'false'

    .PARAMETER FilterExcludeID
        Filter to excluded a certain organization id

    .PARAMETER FilterExcludeName
        Filter to excluded a certain organization name

    .PARAMETER FilterExcludeOrganizationTypeID
        Filter to excluded a certain organization type id

    .PARAMETER FilterExcludeOrganizationStatusID
        Filter to excluded a certain organization status id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueOrganization -Data $JsonObject

        Deletes all defined organization with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Remove-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy_PSA', Mandatory = $true)]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/organizations'

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Destroy*') {
            if ($FilterID)                           { $query_params['filter[id]']                               = $FilterID }
            if ($FilterName)                         { $query_params['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)           { $query_params['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)         { $query_params['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                    { $query_params['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                    { $query_params['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)              { $query_params['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)           { $query_params['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                      { $query_params['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                      { $query_params['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                    { $query_params['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                  { $query_params['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)    { $query_params['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID)  { $query_params['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy_PSA') {
            if ($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Organizations\Remove-ITGlueOrganization.ps1' 210
#Region '.\Public\Organizations\Set-ITGlueOrganization.ps1' -1

function Set-ITGlueOrganization {
<#
    .SYNOPSIS
        Updates one or more organizations

    .DESCRIPTION
        The Set-ITGlueOrganization cmdlet updates the details of an
        existing organization or multiple organizations

        Any attributes you don't specify will remain unchanged

        Returns 422 Bad Request error if trying to update an externally synced record on
        attributes other than: alert, description, quick_notes

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update an organization by id

    .PARAMETER FilterID
        Filter by an organization id

    .PARAMETER FilterName
        Filter by an organization name

    .PARAMETER FilterOrganizationTypeID
        Filter by an organization type id

    .PARAMETER FilterOrganizationStatusID
        Filter by an organization status id

    .PARAMETER FilterCreatedAt
        Filter by when an organization created

    .PARAMETER FilterUpdatedAt
        Filter by when an organization updated

    .PARAMETER FilterMyGlueAccountID
        Filter by a MyGlue id

    .PARAMETER FilterPsaID
        Filter by a PSA id

    .PARAMETER FilterPsaIntegrationType
        Filter by a PSA integration type

        Allowed values:
        'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex'

    .PARAMETER FilterGroupID
        Filter by a group id

    .PARAMETER FilterPrimary
        Filter for primary organization

        Allowed values:
        'true', 'false'

    .PARAMETER FilterExcludeID
        Filter to excluded a certain organization id

    .PARAMETER FilterExcludeName
        Filter to excluded a certain organization name

    .PARAMETER FilterExcludeOrganizationTypeID
        Filter to excluded a certain organization type id

    .PARAMETER FilterExcludeOrganizationStatusID
        Filter to excluded a certain organization status id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueOrganization -id 8765309 -Data $JsonObject

        Updates an organization with the specified JSON object

    .EXAMPLE
        Set-ITGlueOrganization -FilterOrganizationStatusID 12345 -Data $JsonObject

        Updates all defined organization with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/Set-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterOrganizationStatusID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterCreatedAt,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterUpdatedAt,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterMyGlueAccountID,

        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterPsaID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        [ValidateSet( 'manage', 'autotask', 'tigerpaw', 'kaseya-bms', 'pulseway-psa', 'vorex')]
        [string]$FilterPsaIntegrationType,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterGroupID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [ValidateSet( 'true', 'false')]
        [string]$FilterPrimary,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [string]$FilterExcludeName,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeOrganizationTypeID,

        [Parameter(ParameterSetName = 'Bulk_Update')]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA')]
        [int64]$FilterExcludeOrganizationStatusID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update_PSA', Mandatory = $true)]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'Bulk*'     { $ResourceUri = "/organizations" }
            'Update'    { $ResourceUri = "/organizations/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -like 'Bulk_Update*') {
            if ($FilterID)                          { $query_params['filter[id]']                                = $FilterID }
            if ($FilterName)                         { $query_params['filter[name]']                             = $FilterName }
            if ($FilterOrganizationTypeID)           { $query_params['filter[organization_type_id]']             = $FilterOrganizationTypeID }
            if ($FilterOrganizationStatusID)         { $query_params['filter[organization_status_id]']           = $FilterOrganizationStatusID }
            if ($FilterCreatedAt)                    { $query_params['filter[created_at]']                       = $FilterCreatedAt }
            if ($FilterUpdatedAt)                    { $query_params['filter[updated_at]']                       = $FilterUpdatedAt }
            if ($FilterMyGlueAccountID)              { $query_params['filter[my_glue_account_id]']               = $FilterMyGlueAccountID }
            if ($FilterPsaIntegrationType)           { $query_params['filter[psa_integration_type]']             = $FilterPsaIntegrationType }
            if ($FilterGroupID)                      { $query_params['filter[group_id]']                         = $FilterGroupID }
            if ($FilterPrimary)                      { $query_params['filter[primary]']                          = $FilterPrimary }
            if ($FilterExcludeID)                    { $query_params['filter[exclude][id]']                      = $FilterExcludeID }
            if ($FilterExcludeName)                  { $query_params['filter[exclude][name]']                    = $FilterExcludeName }
            if ($FilterExcludeOrganizationTypeID)    { $query_params['filter[exclude][organization_type_id]']    = $FilterExcludeOrganizationTypeID }
            if ($FilterExcludeOrganizationStatusID)  { $query_params['filter[exclude][organization_status_id]']  = $FilterExcludeOrganizationStatusID }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Update_PSA') {
            if ($FilterPsaID) { $query_params['filter[psa_id]'] = $FilterPsaID }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Organizations\Set-ITGlueOrganization.ps1' 227
#Region '.\Public\OrganizationStatuses\Get-ITGlueOrganizationStatus.ps1' -1

function Get-ITGlueOrganizationStatus {
<#
    .SYNOPSIS
        List or show all organization statuses

    .DESCRIPTION
        The Get-ITGlueOrganizationStatus cmdlet returns a list of organization
        statuses or the details of a single organization status in your account

        This function can call the following endpoints:
            Index = /organization_statuses

            Show =  /organization_statuses/:id

    .PARAMETER FilterName
        Filter by organization status name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get an organization status by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOrganizationStatus

        Returns the first 50 organization statuses results from your ITGlue account

    .EXAMPLE
        Get-ITGlueOrganizationStatus -ID 8765309

        Returns the organization statuses with the defined id

    .EXAMPLE
        Get-ITGlueOrganizationStatus -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for organization statuses
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Get-ITGlueOrganizationStatus.html

    .LINK
        https://api.itglue.com/developer/#organization-statuses-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/organization_statuses" }
            'Show'  { $ResourceUri = "/organization_statuses/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\OrganizationStatuses\Get-ITGlueOrganizationStatus.ps1' 133
#Region '.\Public\OrganizationStatuses\New-ITGlueOrganizationStatus.ps1' -1

function New-ITGlueOrganizationStatus {
<#
    .SYNOPSIS
        Create an organization status

    .DESCRIPTION
        The New-ITGlueOrganizationStatus cmdlet creates a new organization
        status in your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueOrganizationStatus -Data $JsonObject

        Creates a new organization status with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/New-ITGlueOrganizationStatus.html

    .LINK
        https://api.itglue.com/developer/#organization-statuses-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/organization_statuses'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\OrganizationStatuses\New-ITGlueOrganizationStatus.ps1' 64
#Region '.\Public\OrganizationStatuses\Set-ITGlueOrganizationStatus.ps1' -1

function Set-ITGlueOrganizationStatus {
<#
    .SYNOPSIS
        Updates an organization status

    .DESCRIPTION
        The Set-ITGlueOrganizationStatus cmdlet updates an organization status
        in your account

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update an organization status by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueOrganizationStatus -id 8675309 -Data $JsonObject

        Using the defined body this creates an attachment to a password with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Set-ITGlueOrganizationStatus.html

    .LINK
        https://api.itglue.com/developer/#organization-statuses-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/organization_statuses/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\OrganizationStatuses\Set-ITGlueOrganizationStatus.ps1' 73
#Region '.\Public\OrganizationTypes\Get-ITGlueOrganizationType.ps1' -1

function Get-ITGlueOrganizationType {
<#
    .SYNOPSIS
        List or show all organization types

    .DESCRIPTION
        The Get-ITGlueOrganizationType cmdlet returns a list of organization types
        or the details of a single organization type in your account

        This function can call the following endpoints:
            Index = /organization_types

            Show =  /organization_types/:id

    .PARAMETER FilterName
        Filter by organization type name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a organization type by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueOrganizationType

        Returns the first 50 organization types from your ITGlue account

    .EXAMPLE
        Get-ITGlueOrganizationType -ID 8765309

        Returns the organization type with the defined id

    .EXAMPLE
        Get-ITGlueOrganizationType -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for organization types
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/Get-ITGlueOrganizationType.html

    .LINK
        https://api.itglue.com/developer/#organization-types-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/organization_types" }
            'Show'  { $ResourceUri = "/organization_types/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end{}

}
#EndRegion '.\Public\OrganizationTypes\Get-ITGlueOrganizationType.ps1' 133
#Region '.\Public\OrganizationTypes\New-ITGlueOrganizationType.ps1' -1

function New-ITGlueOrganizationType {
<#
    .SYNOPSIS
        Creates an organization type

    .DESCRIPTION
        The New-ITGlueOrganizationType cmdlet creates a new organization type
        in your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueOrganizationType -Data $JsonObject

        Creates a new organization type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/New-ITGlueOrganizationType.html

    .LINK
        https://api.itglue.com/developer/#organization-types-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/organization_types'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\OrganizationTypes\New-ITGlueOrganizationType.ps1' 64
#Region '.\Public\OrganizationTypes\Set-ITGlueOrganizationType.ps1' -1

function Set-ITGlueOrganizationType {
<#
    .SYNOPSIS
        Updates an organization type

    .DESCRIPTION
        The Set-ITGlueOrganizationType cmdlet updates an organization type
        in your account

        Returns 422 Bad Request error if trying to update an externally synced record

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update an organization type by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueOrganizationType -id 8675309 -Data $JsonObject

        Update the defined organization type with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationTypes/Set-ITGlueOrganizationType.html

    .LINK
        https://api.itglue.com/developer/#organization-types-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/organization_types/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}
}
#EndRegion '.\Public\OrganizationTypes\Set-ITGlueOrganizationType.ps1' 71
#Region '.\Public\PasswordCategories\Get-ITGluePasswordCategory.ps1' -1

function Get-ITGluePasswordCategory {
<#
    .SYNOPSIS
        List or show all password categories

    .DESCRIPTION
        The Get-ITGluePasswordCategory cmdlet returns a list of password categories
        or the details of a single password category in your account

        This function can call the following endpoints:
            Index = /password_categories

            Show =  /password_categories/:id

    .PARAMETER FilterName
        Filter by a password category name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at',
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a password category by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGluePasswordCategory

        Returns the first 50 password category results from your ITGlue account

    .EXAMPLE
        Get-ITGluePasswordCategory -ID 8765309

        Returns the password category with the defined id

    .EXAMPLE
        Get-ITGluePasswordCategory -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for password categories
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Get-ITGluePasswordCategory.html

    .LINK
        https://api.itglue.com/developer/#password-categories-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/password_categories" }
            'Show'  { $ResourceUri = "/password_categories/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\PasswordCategories\Get-ITGluePasswordCategory.ps1' 133
#Region '.\Public\PasswordCategories\New-ITGluePasswordCategory.ps1' -1

function New-ITGluePasswordCategory {
<#
    .SYNOPSIS
        Creates a password category

    .DESCRIPTION
        The New-ITGluePasswordCategory cmdlet creates a new password category
        in your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGluePasswordCategory -Data $JsonObject

        Creates a new password category with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/New-ITGluePasswordCategory.html

    .LINK
        https://api.itglue.com/developer/#password-categories-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/password_categories'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\PasswordCategories\New-ITGluePasswordCategory.ps1' 64
#Region '.\Public\PasswordCategories\Set-ITGluePasswordCategory.ps1' -1

function Set-ITGluePasswordCategory {
<#
    .SYNOPSIS
        Updates a password category

    .DESCRIPTION
        The Set-ITGluePasswordCategory cmdlet updates a password category
        in your account

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update a password category by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGluePasswordCategory -id 8675309 -Data $JsonObject

        Updates the defined password category with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordCategories/Set-ITGluePasswordCategory.html

    .LINK
        https://api.itglue.com/developer/#password-categories-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/password_categories/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
#EndRegion '.\Public\PasswordCategories\Set-ITGluePasswordCategory.ps1' 70
#Region '.\Public\Passwords\Get-ITGluePassword.ps1' -1

function Get-ITGluePassword {
<#
    .SYNOPSIS
        List or show all passwords

    .DESCRIPTION
        The Get-ITGluePassword cmdlet returns a list of passwords for all organizations,
        a specified organization, or the details of a single password

        To show passwords, your API key needs to have "Password Access" permission

        This function can call the following endpoints:
            Index = /passwords
                    /organizations/:organization_id/relationships/passwords

            Show =  /passwords/:id
                    /organizations/:organization_id/relationships/passwords/:id

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterID
        Filter by password id

    .PARAMETER FilterName
        Filter by password name

    .PARAMETER FilterOrganizationID
        Filter for passwords by organization id

    .PARAMETER FilterPasswordCategoryID
        Filter by passwords category id

    .PARAMETER FilterUrl
        Filter by password url

    .PARAMETER FilterCachedResourceName
        Filter by a passwords cached resource name

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'username', 'id', 'created_at', 'updated-at',
        '-name', '-username', '-id', '-created_at', '-updated-at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a password by id

    .PARAMETER ShowPassword
        Define if the password should be shown or not

        By default ITGlue hides the passwords from the returned data

        Allowed values: (case-sensitive)
        'true', 'false'

    .PARAMETER VersionID
        Set the password's version ID to return it's revision

    .PARAMETER Include
        Include specified assets

        Allowed values (Shared):
        attachments, group_resource_accesses, network_glue_networks,
        rotatable_password,updater,user_resource_accesses

        Allowed values (Index-Unique):
        N/A

        Allowed values (Show-Unique):
        recent_versions, related_items, authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGluePassword

        Returns the first 50 password results from your ITGlue account

    .EXAMPLE
        Get-ITGluePassword -ID 8765309

        Returns the password with the defined id

    .EXAMPLE
        Get-ITGluePassword -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for passwords
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Passwords/Get-ITGluePassword.html

    .LINK
        https://api.itglue.com/developer/#passwords-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterPasswordCategoryID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterUrl,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterCachedResourceName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'username', 'url', 'id', 'created_at', 'updated-at',
                        '-name', '-username', '-url', '-id', '-created_at', '-updated-at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'attachments', 'authorized_users', 'group_resource_accesses',
                        'network_glue_networks', 'recent_versions', 'related_items',
                        'rotatable_password', 'updater', 'user_resource_accesses'
        )]
        $Include,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('true', 'false', IgnoreCase = $false)]
        [string]$ShowPassword,

        [Parameter(ParameterSetName = 'Show')]
        [int64]$VersionID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName){
            'Index' {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords" }
                    $false  { $ResourceUri = "/passwords" }
                }

            }
            'Show'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords/$ID" }
                    $false  { $ResourceUri = "/passwords/$ID" }
                }

            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPasswordCategoryID)  { $query_params['filter[password_category_id]'] = $FilterPasswordCategoryID }
            if ($FilterUrl)                 { $query_params['filter[url]']                  = $FilterUrl }
            if ($FilterCachedResourceName)  { $query_params['filter[cached_resource_name]'] = $FilterCachedResourceName }
            if ($FilterArchived)            { $query_params['filter[archived]']             = $FilterArchived }
            if ($Sort)                      { $query_params['sort']                         = $Sort }
            if ($PageNumber)                { $query_params['page[number]']                 = $PageNumber }
            if ($PageSize)                  { $query_params['page[size]']                   = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'show') {
            if ($ShowPassword)  { $query_params['show_password']    = $ShowPassword }
            if ($VersionID)     { $query_params['version_id']       = $VersionID }
        }

        #Shared Parameters
        if($Include) { $query_params['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Passwords\Get-ITGluePassword.ps1' 250
#Region '.\Public\Passwords\New-ITGluePassword.ps1' -1

function New-ITGluePassword {
<#
    .SYNOPSIS
        Creates one or more a passwords

    .DESCRIPTION
        The New-ITGluePassword cmdlet creates one or more passwords
        under the organization specified in the ID parameter

        To show passwords your API key needs to have the "Password Access" permission

        You can create general and embedded passwords with this endpoint

        If the resource-id and resource-type attributes are NOT provided, IT Glue assumes
        the password is a general password

        If the resource-id and resource-type attributes are provided, IT Glue assumes
        the password is an embedded password

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ShowPassword
        Define if the password should be shown or not

        By default ITGlue hides the passwords from the returned data

        Allowed values: (case-sensitive)
        'true', 'false'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGluePassword -OrganizationID 8675309 -Data $JsonObject

        Creates a new password in the defined organization with the specified JSON object

        The password IS returned in the results

    .EXAMPLE
        New-ITGluePassword -OrganizationID 8675309 -ShowPassword $false -Data $JsonObject

        Creates a new password in the defined organization with the specified JSON object

        The password is NOT returned in the results

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Passwords/New-ITGluePassword.html

    .LINK
        https://api.itglue.com/developer/#passwords-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter()]
        [int64]$OrganizationID,

        [Parameter()]
        [ValidateSet('true', 'false', IgnoreCase = $false)]
        [string]$ShowPassword,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords" }
            $false  { $ResourceUri = "/passwords/" }
        }

        $query_params = @{}

        if ($ShowPassword) { $query_params['show_password'] = $ShowPassword}

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Passwords\New-ITGluePassword.ps1' 110
#Region '.\Public\Passwords\Remove-ITGluePassword.ps1' -1

function Remove-ITGluePassword {
<#
    .SYNOPSIS
        Deletes one or more passwords

    .DESCRIPTION
        The Remove-ITGluePassword cmdlet destroys one or more
        passwords specified by ID

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        Delete a password by id

    .PARAMETER FilterID
        Filter by password id

    .PARAMETER FilterName
        Filter by password name

    .PARAMETER FilterOrganizationID
        Filter for passwords by organization id

    .PARAMETER FilterPasswordCategoryID
        Filter by passwords category id

    .PARAMETER FilterUrl
        Filter by password url

    .PARAMETER FilterCachedResourceName
        Filter by a passwords cached resource name

    .PARAMETER FilterArchived
        Filter for archived

        Allowed values: (case-sensitive)
        'true', 'false', '0', '1'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGluePassword -id 8675309

        Deletes the defined password

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Passwords/Remove-ITGluePassword.html

    .LINK
        https://api.itglue.com/developer/#passwords-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [int64]$FilterPasswordCategoryID,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterUrl,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [string]$FilterCachedResourceName,

        [Parameter(ParameterSetName = 'Bulk_Destroy')]
        [ValidateSet('true','false','0','1', IgnoreCase = $false)]
        [string]$FilterArchived,

        [Parameter(ParameterSetName = 'Bulk_Destroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Destroy'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords/$ID" }
                    $false  { $ResourceUri = "/passwords" }
                }

            }
            'Destroy'       { $ResourceUri = "/passwords/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Bulk_Destroy') {
            if ($FilterID)                  { $query_params['filter[id]']                   = $FilterID }
            if ($FilterName)                { $query_params['filter[name]']                 = $FilterName }
            if ($FilterOrganizationID)      { $query_params['filter[organization_id]']      = $FilterOrganizationID }
            if ($FilterPasswordCategoryID)  { $query_params['filter[password_category_id]'] = $FilterPasswordCategoryID }
            if ($FilterUrl)                 { $query_params['filter[url]']                  = $FilterUrl }
            if ($FilterCachedResourceName)  { $query_params['filter[cached_resource_name]'] = $FilterCachedResourceName }
            if ($FilterArchived)            { $query_params['filter[archived]']             = $FilterArchived }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data -QueryParams $query_params
        }

    }

    end {}

}
#EndRegion '.\Public\Passwords\Remove-ITGluePassword.ps1' 151
#Region '.\Public\Passwords\Set-ITGluePassword.ps1' -1

function Set-ITGluePassword {
<#
    .SYNOPSIS
        Updates one or more passwords

    .DESCRIPTION
        The Set-ITGluePassword cmdlet updates the details of an
        existing password or the details of multiple passwords

        To show passwords your API key needs to have the "Password Access" permission

        Any attributes you don't specify will remain unchanged

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        Update a password by id

    .PARAMETER ShowPassword
        Define if the password should be shown or not

        By default ITGlue hides the passwords from the returned data

        Allowed values: (case-sensitive)
        'true', 'false'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGluePassword -id 8675309 -Data $JsonObject

        Updates the password in the defined organization with the specified JSON object

        The password is NOT returned in the results

    .EXAMPLE
        Set-ITGluePassword -id 8675309 -ShowPassword $true -Data $JsonObject

        Updates the password in the defined organization with the specified JSON object

        The password IS returned in the results

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Passwords/Set-ITGluePassword.html

    .LINK
        https://api.itglue.com/developer/#passwords-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update')]
        [ValidateSet('true', 'false', IgnoreCase = $false)]
        [string]$ShowPassword,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Bulk_Update'  { $ResourceUri = "/passwords" }
            'Update'       {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/passwords/$ID" }
                    $false  { $ResourceUri = "/passwords/$ID" }
                }

            }
        }

        $query_params = @{ 'show_password'= $ShowPassword }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -QueryParams $query_params -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Passwords\Set-ITGluePassword.ps1' 116
#Region '.\Public\Platforms\Get-ITGluePlatform.ps1' -1

function Get-ITGluePlatform {
<#
    .SYNOPSIS
        List or show all platforms

    .DESCRIPTION
        The Get-ITGluePlatform cmdlet returns a list of supported platforms
        or the details of a single platform from your account

        This function can call the following endpoints:
            Index = /platforms

            Show =  /platforms/:id

    .PARAMETER FilterName
        Filter by platform name

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a platform by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGluePlatform

        Returns the first 50 platform results from your ITGlue account

    .EXAMPLE
        Get-ITGluePlatform -ID 8765309

        Returns the platform with the defined id

    .EXAMPLE
        Get-ITGluePlatform -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for platforms
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Platforms/Get-ITGluePlatform.html

    .LINK
        https://api.itglue.com/developer/#platforms-index
#>


    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/platforms" }
            'Show'  { $ResourceUri = "/platforms/$ID" }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)    { $query_params['filter[name]'] = $FilterName }
            if ($Sort)          { $query_params['sort']         = $Sort }
            if ($PageNumber)    { $query_params['page[number]'] = $PageNumber }
            if ($PageSize)      { $query_params['page[size]']   = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Platforms\Get-ITGluePlatform.ps1' 134
#Region '.\Public\Regions\Get-ITGlueRegion.ps1' -1

function Get-ITGlueRegion {
<#
    .SYNOPSIS
        List or show all regions

    .DESCRIPTION
        The Get-ITGlueRegion cmdlet returns a list of supported regions
        or the details of a single support region

        This function can call the following endpoints:
            Index = /regions
                    /countries/:id/relationships/regions

            Show =  /regions/:id
                    /countries/:country_id/relationships/regions/:id

    .PARAMETER CountryID
        Get regions by country id

    .PARAMETER FilterName
        Filter by region name

    .PARAMETER FilterISO
        Filter by region iso abbreviation

    .PARAMETER FilterCountryID
        Filter by country id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'id', 'created_at', 'updated_at',
        '-name', '-id', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a region by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueRegion

        Returns the first 50 region results from your ITGlue account

    .EXAMPLE
        Get-ITGlueRegion -ID 8765309

        Returns the region with the defined id

    .EXAMPLE
        Get-ITGlueRegion -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for regions
        in your ITGlue account

    .NOTES
        2024-09-26 - Using the "country_id" parameter does not appear to
        function at this time for either parameter set

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Regions/Get-ITGlueRegion.html

    .LINK
        https://api.itglue.com/developer/#regions-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$CountryID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterISO,

        [Parameter(ParameterSetName = 'Index')]
        [Int]$FilterCountryID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'id', 'created_at', 'updated_at',
                        '-name', '-id', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' {
                if ($CountryID) {   $ResourceUri = "/countries/$CountryID/relationships/regions" }
                else{               $ResourceUri = "/regions" }
            }
            'Show'  {
                if ($CountryID) {   $ResourceUri = "/countries/$CountryID/relationships/regions/$ID" }
                else{               $ResourceUri = "/regions/$ID" }
            }
        }

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterName)        { $query_params['filter[name]']         = $FilterName }
            if ($FilterISO)         { $query_params['filter[iso]']          = $FilterISO }
            if ($FilterCountryID)   { $query_params['filter[CountryID]']    = $FilterCountryID }
            if ($Sort)              { $query_params['sort']                 = $Sort }
            if ($PageNumber)        { $query_params['page[number]']         = $PageNumber }
            if ($PageSize)          { $query_params['page[size]']           = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Regions\Get-ITGlueRegion.ps1' 163
#Region '.\Public\RelatedItems\New-ITGlueRelatedItem.ps1' -1

function New-ITGlueRelatedItem {
<#
    .SYNOPSIS
        Creates one or more related items

    .DESCRIPTION
        The New-ITGlueRelatedItem cmdlet creates one or more related items

        The create action is directional from source item to destination item(s)

        The source item is the item that matches the resource_type and resource_id in the URL

        The destination item(s) are the items that match the destination_type
        and destination_id in the JSON object

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts',
        'documents', 'domains', 'folders', 'locations', 'passwords', 'ssl_certificates',
        'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -Data $JsonObject

        Creates a new related password to the defined resource id with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/New-ITGlueRelatedItem.html

    .LINK
        https://api.itglue.com/developer/#related-items-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains','folders', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/related_items"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\RelatedItems\New-ITGlueRelatedItem.ps1' 91
#Region '.\Public\RelatedItems\Remove-ITGlueRelatedItem.ps1' -1

function Remove-ITGlueRelatedItem {
<#
    .SYNOPSIS
        Deletes one or more related items

    .DESCRIPTION
        The Remove-ITGlueRelatedItem cmdlet deletes one or more specified
        related items

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts',
        'documents', 'domains', 'folders', 'locations', 'passwords', 'ssl_certificates',
        'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The id of the related item

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -Data $JsonObject

        Deletes the defined related item on the defined resource with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Remove-ITGlueRelatedItem.html

    .LINK
        https://api.itglue.com/developer/#related-items-bulk-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains','folders', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/related_items"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\RelatedItems\Remove-ITGlueRelatedItem.ps1' 85
#Region '.\Public\RelatedItems\Set-ITGlueRelatedItem.ps1' -1

function Set-ITGlueRelatedItem {
<#
    .SYNOPSIS
        Updates a related item for a particular resource

    .DESCRIPTION
        The Set-ITGlueRelatedItem cmdlet updates a related item for
        a particular resource

        Only the related item notes that are displayed on the
        asset view screen can be changed

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts',
        'documents', 'domains', 'folders', 'locations', 'passwords', 'ssl_certificates',
        'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER ID
        The id of the related item

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -ID 8765309 -Data $JsonObject

        Updates the defined related item on the defined resource with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Set-ITGlueRelatedItem.html

    .LINK
        https://api.itglue.com/developer/#related-items-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains','folders', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/related_items/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}
}
#EndRegion '.\Public\RelatedItems\Set-ITGlueRelatedItem.ps1' 94
#Region '.\Public\UserMetrics\Get-ITGlueUserMetric.ps1' -1

function Get-ITGlueUserMetric {
<#
    .SYNOPSIS
        Lists all user metrics

    .DESCRIPTION
        The Get-ITGlueUserMetric cmdlet lists all user metrics

    .PARAMETER FilterUserID
        Filter by user id

    .PARAMETER FilterOrganizationID
        Filter for users metrics by organization id

    .PARAMETER FilterResourceType
        Filter for user metrics by resource type

        Example:
            'Configurations','Passwords','Active Directory'

    .PARAMETER FilterDate
        Filter for users metrics by a date range

        The dates are UTC

        The specified string must be a date range and comma-separated start_date, end_date

        Use * for unspecified start_date or end_date

        Date ranges longer than a week may be disallowed for performance reasons

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'id', 'created', 'viewed', 'edited', 'deleted', 'date',
        '-id', '-created', '-viewed', '-edited', '-deleted', '-date'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueUserMetric

        Returns the first 50 user metric results from your ITGlue account

    .EXAMPLE
        Get-ITGlueUserMetric -FilterUserID 12345

        Returns the user metric for the user with the defined id

    .EXAMPLE
        Get-ITGlueUserMetric -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for user metrics
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/UserMetrics/Get-ITGlueUserMetric.html

    .LINK
        https://api.itglue.com/developer/#accounts-user-metrics-daily-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterUserID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceType,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterDate,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'id', 'created', 'viewed', 'edited', 'deleted', 'date',
                        '-id', '-created', '-viewed', '-edited', '-deleted', '-date')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/user_metrics'

        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterUserID)          { $query_params['filter[user_id]']          = $FilterUserID }
            if ($FilterOrganizationID)  { $query_params['filter[organization_id]']  = $FilterOrganizationID }
            if ($FilterResourceType)    { $query_params['filter[resource_type]']    = $FilterResourceType }
            if ($FilterDate)            { $query_params['filter[date]']             = $FilterDate }
            if ($Sort)                  { $query_params['sort']                     = $Sort }
            if ($PageNumber)            { $query_params['page[number]']             = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']               = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\UserMetrics\Get-ITGlueUserMetric.ps1' 150
#Region '.\Public\Users\Get-ITGlueUser.ps1' -1

function Get-ITGlueUser {
<#
    .SYNOPSIS
        List or show all users

    .DESCRIPTION
        The Get-ITGlueUser cmdlet returns a list of the users
        or the details of a single user in your account

        This function can call the following endpoints:
            Index = /users

            Show =  /users/:id

    .PARAMETER FilterID
        Filter by user ID

    .PARAMETER FilterName
        Filter by user name

    .PARAMETER FilterEmail
        Filter by user email address

    .PARAMETER FilterRoleName
        Filter by a users role

        Allowed values:
            'Administrator', 'Manager', 'Editor', 'Creator', 'Lite', 'Read-only'

    .PARAMETER FilterSalesforceID
        Filter by Salesforce ID

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'email', 'reputation', 'id', 'created_at', 'updated-at',
        '-name', '-email', '-reputation', '-id', '-created_at', '-updated-at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a user by id

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueUser

        Returns the first 50 user results from your ITGlue account

    .EXAMPLE
        Get-ITGlueUser -ID 8765309

        Returns the user with the defined id

    .EXAMPLE
        Get-ITGlueUser -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for users
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Users/Get-ITGlueUser.html

    .LINK
        https://api.itglue.com/developer/#accounts-users-index
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterName,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterEmail,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet('Administrator', 'Manager', 'Editor', 'Creator', 'Lite', 'Read-only')]
        [string]$FilterRoleName,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterSalesForceID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'email', 'reputation', 'id', 'created_at', 'updated-at',
                        '-name', '-email', '-reputation', '-id', '-created_at', '-updated-at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/users" }
            'Show'  { $ResourceUri = "/users/$ID" }
        }


        $query_params = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $query_params['filter[id]']               = $FilterID }
            if ($FilterName)            { $query_params['filter[name]']             = $FilterName }
            if ($FilterEmail)           { $query_params['filter[email]']            = $FilterEmail }
            if ($FilterRoleName)        { $query_params['filter[role_name]']        = $FilterRoleName }
            if ($FilterSalesForceID)    { $query_params['filter[salesforce_id]']    = $FilterSalesForceID }
            if ($Sort)                  { $query_params['sort']                     = $Sort }
            if ($PageNumber)            { $query_params['page[number]']             = $PageNumber }
            if ($PageSize)              { $query_params['page[size]']               = $PageSize }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -QueryParams $query_params -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Users\Get-ITGlueUser.ps1' 166
#Region '.\Public\Users\Set-ITGlueUser.ps1' -1

function Set-ITGlueUser {
<#
    .SYNOPSIS
        Updates the name or profile picture of an existing user

    .DESCRIPTION
        The Set-ITGlueUser cmdlet updates the name or profile picture (avatar)
        of an existing user

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER ID
        Update by user id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueUser -id 8675309 -Data $JsonObject

        Updates the defined user with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Users/Set-ITGlueUser.html

    .LINK
        https://api.itglue.com/developer/#accounts-users-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/users/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Users\Set-ITGlueUser.ps1' 70
