function ConvertTo-ITGlueQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The ConvertTo-ITGlueQueryString cmdlet converts & formats uri query parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        ConvertTo-ITGlueQueryString & any public functions that define parameters

    .PARAMETER UriFilter
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

    .EXAMPLE
        ConvertTo-ITGlueQueryString -UriFilter $HashTable

        Example HashTable:
            $UriParameters = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Internal/ConvertTo-ITGlueQueryString.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Convert')]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$UriFilter
    )

    begin {}

    process{

        if (-not $UriFilter) {
            return ""
        }

        $params = @()
        foreach ($key in $UriFilter.Keys) {
            $value = [System.Net.WebUtility]::UrlEncode($UriFilter[$key])
            $params += "$key=$value"
        }

        $QueryString = '?' + ($params -join '&')
        return $QueryString

    }

    end{}

}
