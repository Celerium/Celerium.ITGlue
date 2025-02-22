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
