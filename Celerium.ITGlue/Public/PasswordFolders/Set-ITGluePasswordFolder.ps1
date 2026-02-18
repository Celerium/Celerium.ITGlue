function Set-ITGluePasswordFolder {
<#
    .SYNOPSIS
        Updates the details of an existing or list of password folders

    .DESCRIPTION
        The Set-ITGluePasswordFolder cmdlet updates the details of an existing
        or list of password folders

        Bulk updates using a nested relationships route are NOT supported

        It will accept a partial representation of objects, as long as the required
        parameters are present.

        Any attributes you don't specify will remain unchanged

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER Id
        Password folder id

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGluePasswordFolder -OrganizationID 12345 -Id 8765309 -Data $JsonBody

        Updates an existing password folder with the defined JSON object

    .EXAMPLE
        Set-ITGluePasswordFolder -Data $JsonBody

        Updates an existing password folder with the defined JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/PasswordFolders/Set-ITGluePasswordFolder.html

    .LINK
        https://api.itglue.com/developer/#password-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'BulkUpdate', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update', ValueFromPipeline = $true, Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$Id,

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
            'Update'        { $ResourceUri = "/organizations/$OrganizationID/relationships/password_folders/$Id" }
            'BulkUpdate'    { $ResourceUri = "/password_folders" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data

    }

    end {}

}
