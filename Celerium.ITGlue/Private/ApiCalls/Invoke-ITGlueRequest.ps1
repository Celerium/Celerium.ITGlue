function Invoke-ITGlueRequest {
<#
    .SYNOPSIS
        Makes an API request to ITGlue

    .DESCRIPTION
        The Invoke-ITGlueRequest cmdlet invokes an API request to the ITGlue API

        This is an internal function that is used by all public functions

    .PARAMETER Method
        Defines the type of API method to use

        Allowed values:
        'GET', 'POST', 'PATCH', 'DELETE'

    .PARAMETER ResourceURI
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER UriFilter
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
        Invoke-ITGlueRequest -Method GET -ResourceURI '/passwords' -UriFilter $UriFilter

        Invoke a rest method against the defined resource using the provided parameters

        Example HashTable:
            $UriParameters = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/Invoke-ITGlueRequest.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Invoke', SupportsShouldProcess)]
    param (
        [Parameter()]
        [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter(Mandatory = $true)]
        [string]$ResourceURI,

        [Parameter()]
        [hashtable]$UriFilter,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $Data,

        [Parameter()]
        [switch]$AllResults
    )

    begin {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $Result = @{}

        switch ([bool]$Data) {
            $true   { $Body = @{'data'=$Data} | ConvertTo-Json -Depth $ITGlueModuleJSONConversionDepth }
            $false  { $Body = $null }
        }

        try {

            $Headers = @{ 'x-api-key' = Get-ITGlueAPIKey -AsPlainText }

            $page = 0

            do {

                $page++

                if($AllResults) {
                    if(-not $UriFilter) { $UriFilter = @{} }
                    $UriFilter['page[number]'] = $page
                }

                if ($UriFilter) {
                    $QueryString = ConvertTo-ITGlueQueryString -UriFilter $UriFilter
                    Set-Variable -Name $QueryParameterName -Value $QueryString -Scope Global -Force -Confirm:$false
                }

                $parameters = @{
                    'Method'    = $Method
                    'Uri'       = $ITGlueModuleBaseURI + $ResourceURI + $QueryString
                    'Headers'   = $Headers
                    'Body'      = $Body
                }

                if($Method -ne 'GET') {
                    $parameters['ContentType'] = 'application/vnd.api+json; charset=utf-8'
                }

                Set-Variable -Name $ParameterName -Value $parameters -Scope Global -Force -Confirm:$false

                $ApiResponse = Invoke-RestMethod @parameters -ErrorAction Stop

                Write-Verbose "[ $page ] of [ $($ApiResponse.meta.'total-pages') ] pages"

                switch ($AllResults) {
                    $true   { $Result.data += $ApiResponse.data }
                    $false  { $Result = $ApiResponse }
                }

            } while($AllResults -and $ApiResponse.meta.'total-pages' -and $page -lt ($ApiResponse.meta.'total-pages'))

            if($AllResults -and $ApiResponse.meta) {
                $Result.meta = $ApiResponse.meta
                if($Result.meta.'current-page') { $Result.meta.'current-page'   = 1 }
                if($Result.meta.'next-page')    { $Result.meta.'next-page'      = '' }
                if($Result.meta.'prev-page')    { $Result.meta.'prev-page'      = '' }
                if($Result.meta.'total-pages')  { $Result.meta.'total-pages'    = 1 }
                if($Result.meta.'total-count')  { $Result.meta.'total-count'    = $Result.data.count }
            }

        }
        catch {

            $ExceptionError = $_.Exception.Message
            Write-Warning 'The [ Invoke_ITGlueRequest_Parameters, Invoke_ITGlueRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

            switch -Wildcard ($ExceptionError) {
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

        return $Result

    }

    end {}

}
