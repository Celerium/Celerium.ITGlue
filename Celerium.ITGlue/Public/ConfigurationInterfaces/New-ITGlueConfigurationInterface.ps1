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
        New-ITGlueConfigurationInterface -ConfigurationID 8765309 -Data $JsonBody

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
