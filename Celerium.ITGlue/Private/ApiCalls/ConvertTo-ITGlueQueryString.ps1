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
