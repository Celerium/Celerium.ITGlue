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
