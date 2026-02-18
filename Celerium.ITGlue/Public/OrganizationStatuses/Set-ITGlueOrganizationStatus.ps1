function Set-ITGlueOrganizationStatus {
<#
    .SYNOPSIS
        Updates an organization status

    .DESCRIPTION
        The Set-ITGlueOrganizationStatus cmdlet updates an organization status
        in your account

        Returns 422 Bad Request error if trying to update an externally synced record

    .PARAMETER ID
        Update an organization status by id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueOrganizationStatus -id 8675309 -Data $JsonBody

        Using the defined body this creates an attachment to a password with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/OrganizationStatuses/Set-ITGlueOrganizationStatus.html

    .LINK
        https://api.itglue.com/developer/#organization-statuses
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [int64]$ID,

        [Parameter(Mandatory = $true)]
        $Data
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
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}
