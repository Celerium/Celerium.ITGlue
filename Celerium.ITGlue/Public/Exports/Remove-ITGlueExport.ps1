function Remove-ITGlueExport {
<#
    .SYNOPSIS
        Deletes an export

    .DESCRIPTION
        The Remove-ITGlueExport cmdlet deletes an export

    .PARAMETER ID
        ID of export to delete

    .EXAMPLE
        Remove-ITGlueExport -ID 8675309

        Deletes the export with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Exports/Remove-ITGlueExport.html

    .LINK
        https://api.itglue.com/developer/#exports-destroy
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/exports/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
