function New-ITGlueResourceAccess {
<#
    .SYNOPSIS
        Create resource accesses for a defined resource

    .DESCRIPTION
        The New-ITGlueResourceAccess cmdlet gives users or groups access
        to a defined resource

        Add user/group resource accesses to the resource specified in the ID parameter

    .PARAMETER ResourceType
        The resource type of the parent resource

        Allowed values:
        'checklists', 'configurations', 'contacts', 'documents', 'document_folders', 'domains',
        'locations', 'password_folders', 'passwords', 'ssl_certificates', 'flexible_assets'

    .PARAMETER ResourceID
        The resource id of the parent resource

    .PARAMETER Type
        The resource type of the parent resource

        Allowed values:
        'resource-accesses'

    .PARAMETER AccessorType
        The resource type of the accessor

        Allowed values:
        'User', 'Group'

    .PARAMETER AccessorID
        The ID of the accessor

        Allowed values:
        'User', 'Group'

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueResourceAccess -ResourceType 'documents' -ResourceID 8675309 -AccessorType 'User' -AccessorID 1234567

        Creates a new resource access for the specified document with the specified user

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/ResourceAccesses/New-ITGlueResourceAccess.html

    .LINK
        https://api.itglue.com/developer#resource-accesses
#>

    [CmdletBinding(DefaultParameterSetName = 'CreateByData', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet (  'checklists', 'configurations', 'contacts', 'documents', 'document_folders', 'domains',
                        'locations', 'password_folders', 'passwords', 'ssl_certificates', 'flexible_assets'
        )]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int64]$ResourceID,

        [Parameter(ParameterSetName = 'Create')]
        [ValidateSet('resource-accesses')]
        [string]$Type = 'resource-accesses',

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        [ValidateSet('User', 'Group')]
        [string]$AccessorType,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int64]$AccessorID,

        [Parameter(ParameterSetName = 'CreateByData', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/$ResourceType/$ResourceID/relationships/resource_accesses"

        if ($PSCmdlet.ParameterSetName -eq 'Create') {
            $Data = @{
                type        = $Type
                attributes  = @{
                    'accessor-type' = $AccessorType
                    'accessor-id'   = $AccessorID
                }
            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
