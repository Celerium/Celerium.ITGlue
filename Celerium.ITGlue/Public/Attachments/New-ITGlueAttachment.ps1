function New-ITGlueAttachment {
<#
    .SYNOPSIS
        Adds an attachment to one or more assets

    .DESCRIPTION
        The New-ITGlueAttachment cmdlet adds an attachment
        to one or more assets

        Attachments are uploaded by including media data on the asset the attachment
        is associated with. Attachments can be encoded and passed in JSON format for
        direct upload, in which case the file has to be strict encoded

        Note that the name of the attachment will be taken from the file_name attribute
        placed in the JSON body

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'checklist_templates', 'configurations', 'contacts', 'documents',
        'domains', 'locations', 'passwords', 'ssl_certificates', 'flexible_assets', 'tickets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueAttachment -ResourceType passwords -ResourceID 8675309 -Data $JsonBody

        Creates an attachment to a password with the defined id using the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Attachments/New-ITGlueAttachment.html

    .LINK
        https://api.itglue.com/developer/#attachments
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(   'checklists', 'checklist_templates', 'configurations', 'contacts',
                        'documents','domains', 'locations', 'passwords', 'ssl_certificates',
                        'flexible_assets', 'tickets'
        )]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [int64]$ResourceID,

        [Parameter(Mandatory = $true)]
        $Data
    )

    begin{

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process{

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/attachments"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($Data)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end{}

}