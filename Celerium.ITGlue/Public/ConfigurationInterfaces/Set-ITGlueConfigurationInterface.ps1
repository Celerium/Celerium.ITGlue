function Set-ITGlueConfigurationInterface {
<#
    .SYNOPSIS
        Update one or more configuration interfaces

    .DESCRIPTION
        The Set-ITGlueConfigurationInterface cmdlet updates one
        or more configuration interfaces

        Any attributes you don't specify will remain unchanged

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
        Set-ITGlueConfigurationInterface -ID 8765309 -Data $JsonBody

        Updates an interface for the defined configuration with the structured
        JSON object

    .EXAMPLE
        Set-ITGlueConfigurationInterface -FilterID 8765309 -Data $JsonBody

        Bulk updates interfaces associated to the defined configuration filter
        with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ConfigurationInterfaces/Set-ITGlueConfigurationInterface.html

    .LINK
        https://api.itglue.com/developer/#configuration-interfaces
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [int64]$ConfigurationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'BulkUpdate')]
        [string]$FilterIPAddress,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
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
            'BulkUpdate'  { $ResourceUri = "/configuration_interfaces" }
            'Update' {

                switch ([bool]$ConfigurationID) {
                    $true   { $ResourceUri = "/configurations/$ConfigurationID/relationships/configuration_interfaces/$ID" }
                    $false  { $ResourceUri = "/configuration_interfaces/$ID" }
                }

            }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'BulkUpdate') {
            if ($FilterID)          { $UriParameters['filter[id]']           = $FilterID }
            if ($FilterIPAddress)   { $UriParameters['filter[ip_address]']   = $FilterIPAddress }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -UriFilter $UriParameters -Data $Data
        }

    }

    end {}

}
