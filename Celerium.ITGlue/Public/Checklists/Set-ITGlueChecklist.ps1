function Set-ITGlueChecklist {
<#
    .SYNOPSIS
        Update a single checklist or multiple checklists

    .DESCRIPTION
        The Set-ITGlueChecklist cmdlet updates one or
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
        Set-ITGlueChecklist -id 8675309 -Data $JsonBody

        Updates the defined checklist with the specified JSON body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Checklists/Set-ITGlueChecklist.html

    .LINK
        https://api.itglue.com/developer/#checklists
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [Parameter(ParameterSetName = 'BulkUpdate')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'BulkUpdate', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/checklists/$ID" }
                    $false  { $ResourceUri = "/checklists/$ID" }
                }

            }
            'BulkUpdate'   {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/checklists" }
                    $false  { $ResourceUri = "/checklists" }
                }

            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}

