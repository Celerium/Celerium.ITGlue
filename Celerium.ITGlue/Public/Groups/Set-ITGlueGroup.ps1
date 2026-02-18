function Set-ITGlueGroup {
<#
    .SYNOPSIS
        Updates a group or a list of groups in bulk

    .DESCRIPTION
        The Set-ITGlueGroup cmdlet updates a group or a list of
        groups in bulk

        It accepts a partial representation of each group-only the
        attributes you provide will be updated; all others remain unchanged

    .PARAMETER Id
        Group id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueGroup -Id 12345 -Data $JsonBody

        Updates the group with the specified id using the structured JSON object

    .EXAMPLE
        Set-ITGlueGroup -Data $JsonBody

        Updates a group or a list of groups with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Groups/Set-ITGlueGroup.html

    .LINK
        https://api.itglue.com/developer/#groups
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', ValueFromPipeline = $true , Mandatory = $true)]
        $Id,

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
            'Update'        { $ResourceUri = "/groups/$Id" }
            'BulkUpdate'    { $ResourceUri = "/groups" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data


    }

    end {}

}
