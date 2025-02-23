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

        $WebAssembly = [System.Reflection.Assembly]::GetAssembly([System.Web.HttpUtility])
        Write-Verbose "TEST -- Checking for System.Web assembly [ $($WebAssembly.FullName) ]"

        Write-Verbose "TEST -- All loadedAssemblies loaded [ $($loadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies() | Select-Object -ExpandProperty FullName) ]"

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
