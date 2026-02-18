function Set-ITGlueRelatedItem {
<#
    .SYNOPSIS
        Updates a related item for a particular resource

    .DESCRIPTION
        The Set-ITGlueRelatedItem cmdlet updates a related item for
        a particular resource

        Only the related item notes that are displayed on the
        asset view screen can be changed

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts',
        'documents', 'domains', 'folders', 'locations', 'passwords', 'ssl_certificates',
        'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER ID
        The id of the related item

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueRelatedItem -ResourceType passwords -ResourceID 8675309 -ID 8765309 -Data $JsonBody

        Updates the defined related item on the defined resource with the structured
        JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/RelatedItems/Set-ITGlueRelatedItem.html

    .LINK
        https://api.itglue.com/developer/#related-items
#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains','folders', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

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

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/related_items/$ID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}
}
