function New-ITGlueGroup {
<#
    .SYNOPSIS
        Creates a group

    .DESCRIPTION
        The New-ITGlueGroup cmdlet creates a group

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueGroup -Data $JsonBody

        Creates a new group with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Groups/New-ITGlueGroup.html

    .LINK
        https://api.itglue.com/developer/#groups
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Create', ValueFromPipeline = $true , Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/groups"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data

    }

    end {}

}
