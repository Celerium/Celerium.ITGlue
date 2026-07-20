function Remove-ITGlueOrganizationStatus {
<#
    .SYNOPSIS
        Deletes an organization status

    .DESCRIPTION
        The Remove-ITGlueOrganizationStatus cmdlet deletes an
        organization status

        Statuses like ('Active', 'Inactive') cannot be deleted
        Statuses actively synced with an adapter cannot be deleted (423)
        Statuses referenced by one or more organizations cannot be deleted

    .PARAMETER ID
        Status ID to delete

    .EXAMPLE
        Remove-ITGlueOrganizationStatus -ID 8765309

        Deletes the organization status with the specified ID

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Remove-ITGlueOrganizationStatus.html

    .LINK
        https://api.itglue.com/developer/#organization-statuses
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'High')]
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

        $ResourceUri = "/organization_statuses/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
