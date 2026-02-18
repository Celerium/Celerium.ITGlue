function Remove-ITGlueChecklist {
<#
    .SYNOPSIS
        Deletes one or more checklists

    .DESCRIPTION
        The Remove-ITGlueChecklist cmdlet deletes one or
        more specified checklists

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        A valid checklist id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

        .EXAMPLE
        Remove-ITGlueChecklist -OrganizationID 12345 -ID 8765309

        Deletes the defined checklist

        .EXAMPLE
        Remove-ITGlueChecklist -OrganizationID 12345 -Data $JsonBody

        Deletes the defined checklist with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Checklists/Remove-ITGlueChecklist.html

    .LINK
        https://api.itglue.com/developer/#checklists
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'Destroy')]
        [Parameter(ParameterSetName = 'BulkDestroy')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Destroy', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ([bool]$OrganizationID) {
            $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/checklists" }
            $false  { $ResourceUri = "/checklists" }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Destroy') {
            $Data = @{
                type        = 'checklists'
                attributes  = @{
                    id = $ID
                }
            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}

