function New-ITGlueModel {
<#
    .SYNOPSIS
        Creates one or more models

    .DESCRIPTION
        The New-ITGlueModel cmdlet creates one or more models
        in your account or for a particular manufacturer

    .PARAMETER ManufacturerID
        The manufacturer id to create the model under

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueModel -Data $JsonBody

        Creates a new model with the specified JSON body

    .EXAMPLE
        New-ITGlueModel -ManufacturerID 8675309 -Data $JsonBody

        Creates a new model associated to the defined model with the
        structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Models/Get-ITGlueModel.html

    .LINK
        https://api.itglue.com/developer/#models
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
