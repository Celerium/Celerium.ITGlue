function Remove-ITGlueGroup {
<#
    .SYNOPSIS
        Deletes a group

    .DESCRIPTION
        The Remove-ITGlueGroup cmdlet deletes a group

    .PARAMETER Id
        Group id

    .EXAMPLE
        Remove-ITGlueGroup -Id 12345

        Deletes the group with the specified id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Groups/Remove-ITGlueGroup.html

    .LINK
        https://api.itglue.com/developer/#groups
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy', ValueFromPipeline = $true , Mandatory = $true)]
        $Id
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/groups/$Id"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri


    }

    end {}

}
