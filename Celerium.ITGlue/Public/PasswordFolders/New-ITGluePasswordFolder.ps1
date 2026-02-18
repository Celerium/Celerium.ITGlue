function New-ITGluePasswordFolder {
<#
    .SYNOPSIS
        Creates a new password folder

    .DESCRIPTION
        The New-ITGluePasswordFolder cmdlet creates a new password folder
        under the organization specified in the ID parameter.

        Returns the created object if successful.

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER Name
        The name of the new password folder

    .PARAMETER Restricted
        Restrict access to the password folder

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGluePasswordFolder -OrganizationID 12345 -Name "New Folder" -Restricted

        Creates a new password folder with the defined name with restricted access

    .EXAMPLE
        New-ITGluePasswordFolder -OrganizationID 12345 -Data $JsonBody

        Creates a new password folder with the defined JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/New-ITGluePasswordFolder.html

    .LINK
        https://api.itglue.com/developer/#password-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Create', ValueFromPipeline = $true, Mandatory = $true)]
        [Parameter(ParameterSetName = 'CreateSimple', ValueFromPipeline = $true, Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'CreateSimple', Mandatory = $true)]
        [string]$Name,

        [Parameter(ParameterSetName = 'CreateSimple')]
        [switch]$Restricted,

        [Parameter(ParameterSetName = 'Create', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/organizations/$OrganizationID/relationships/password_folders"

        if ($PSCmdlet.ParameterSetName -eq 'CreateSimple') {
            $Data = @{
                type        = 'password_folders'
                attributes  = @{
                    name        = $Name
                    restricted  = if($Restricted) { 'true' } else { 'false' }
                }
            }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data

    }

    end {}

}
