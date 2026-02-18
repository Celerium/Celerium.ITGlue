function Get-ITGlueAttachment {
<#
    .SYNOPSIS
        List or show attachments for a resource

    .DESCRIPTION
        The Get-ITGlueAttachment cmdlet returns a list and or
        shows attachments for a resource

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed Values:
        'checklists', 'checklist_templates', 'configurations', 'contacts',
        'documents', 'domains', 'locations', 'passwords', 'ssl_certificates',
        'flexible_assets', 'tickets

    .PARAMETER ResourceId
        The resource id of the parent resource

    .PARAMETER Id
        Attachment id

    .EXAMPLE
        Get-ITGlueAttachment -ResourceType 'checklists' -ResourceId 12345

        Returns the defined attachments for the parent resource

    .EXAMPLE
        Get-ITGlueAttachment -ResourceType 'checklists' -ResourceId 12345 -Id 8765309

        Returns the defined attachment for the parent resource

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Attachments/Get-ITGlueAttachment.html

    .LINK
        https://api.itglue.com/developer/#attachments
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show', Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents', 'domains', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets')]
        [string]$ResourceType,

        [Parameter(ParameterSetName = 'Index', ValueFromPipeline = $true , Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ResourceId,

        [Parameter(ParameterSetName = 'Show', Mandatory = $true)]
        [int64]$Id
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/$ResourceType/$ResourceId/relationships/attachments" }
            'Show'  { $ResourceUri = "/$ResourceType/$ResourceId/relationships/attachments/$Id" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri

    }

    end {}

}
