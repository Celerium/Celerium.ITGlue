function Remove-ITGluePasswordFolder {
<#
    .SYNOPSIS
        Delete multiple password folders for a particular organization

    .DESCRIPTION
        The Remove-ITGluePasswordFolder cmdlet deletes one or more
        specified password folders

        Returns the deleted password folders and a 200 status code if successful
        Returns 422 Unprocessable Entity error if trying to delete a password folder
        that has dependent folders or passwords.

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Remove-ITGluePasswordFolder -OrganizationID 12345 -Data $JsonBody

        Deletes one or more specified password folders with the defined JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Remove-ITGluePasswordFolder.html

    .LINK
        https://api.itglue.com/developer/#password-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkDestroy', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(ParameterSetName = 'BulkDestroy', ValueFromPipeline = $true, Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'BulkDestroy', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/organizations/$OrganizationID/relationships/password_folders"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method DELETE -ResourceURI $ResourceUri -Data $Data

    }

    end {}

}
