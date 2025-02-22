<#
    .SYNOPSIS
        Pulls group information

    .DESCRIPTION
        The Invoke-ExampleITGlueGroup script pulls a
        defined groups information and or also shows
        all members of defined group

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the group

    .PARAMETER IncludeMembers
        Show members of the defined group id

    .EXAMPLE
        .\Invoke-ExampleITGlueGroup.ps1

        Show a random groups information, no members are included

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueGroup.ps1 -ID 12345 -IncludeMembers -Verbose

        Show the defined group information included its associated members

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#groups

    .LINK
        https://github.com/Celerium/Celerium.ITGlue
#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 3.0
<# #Requires -Modules @{ ModuleName='Celerium.ITGlue'; ModuleVersion='2.2.0' } #>

#Region     [ Parameters ]

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$APIKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$APIUri,

        [Parameter()]
        [int64]$ID,

        [Parameter()]
        [switch]$IncludeMembers

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1

    Import-Module Celerium.ITGlue -Verbose:$false

    #Setting up ITGlue APIKey, BaseURI & Validate "UserIcons" folder Path
    try {

        if ($APIKey) { Add-ITGlueAPIKey $APIKey }
        if([bool]$(Get-ITGlueAPIKey -WarningAction SilentlyContinue) -eq $false) {
            Throw "The ITGlue API [ secret ] key is not set. Run Add-ITGlueAPIKey to set the API key."
        }

        if ($APIUri) { Add-ITGlueBaseURI -BaseUri $APIUri }
        if([bool]$(Get-ITGlueBaseURI -WarningAction SilentlyContinue) -eq $false) {
            Add-ITGlueBaseURI
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Using [ $(Get-ITGlueBaseURI) ]"
        }

    }
    catch {
        Write-Error $_
        exit 1
    }

#EndRegion  [ Prerequisites ]

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Finding Group"
    $StepNumber++

#Region     [ Find Existing User ]

try {

    if ($ID) {

        switch ($IncludeMembers) {
            $true   { $ITGlueGroup = (Get-ITGlueGroup -ID $ID -Include users) }
            $false  { $ITGlueGroup = (Get-ITGlueGroup -ID $ID) }
        }

        if ($null -eq $ITGlueGroup.data.id) {
            Throw "No group found with an ID of [ $ID ], please verify group ID and try again"
        }

    }
    else{

        $RandomGroup = (Get-ITGlueGroup -AllResults).data | Get-Random -Count 1

        switch ($IncludeMembers) {
            $true   { $ITGlueGroup = Get-ITGlueGroup -ID $RandomGroup.id -Include users }
            $false  { $ITGlueGroup = (Get-ITGlueGroup -ID $RandomGroup.id) }
        }

        if ($null -eq $ITGlueGroup.data.id) {
            Throw "No groups found, please create an ITGlue group first and try again"
        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found group [ $($ITGlueGroup.data.attributes.name) - $($ITGlueGroup.data.id) ]"

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting group information"
$StepNumber++

#Region     [ Group Information ]

    switch ([bool]$IncludeMembers) {
        $true   {

            if ($null -eq $ITGlueGroup.included.id) {

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - No members found in [ $($ITGlueGroup.data.attributes.name) - $($ITGlueGroup.data.id) ]"
                $ExampleReturnData = $ITGlueGroup.data.attributes

            }
            else {

                $ExampleReturnData = [System.Collections.Generic.List[object]]::new()

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - [ $( ($ITGlueGroup.included.id | Measure-Object).Count ) ] members found in [ $($ITGlueGroup.data.attributes.name) - $($ITGlueGroup.data.id) ]"

                foreach ($User in $ITGlueGroup.included.attributes) {
                    $data = [PSCustomObject]@{
                        GroupName           = $ITGlueGroup.data.attributes.Name
                        GroupID             = $ITGlueGroup.data.id
                        GroupDescription    = $ITGlueGroup.data.attributes.description
                        UserName            = $User.name
                        UserRole            = $User.'role-name'
                        UserCurrentSignIn   = $User.'current-sign-in-at'
                        UserLastSignIn      = $User.'last-sign-in-at'
                    }
                    $ExampleReturnData.Add($data) > $null
                }

            }

        }
        $false  {

            $ExampleReturnData = $ITGlueGroup.data.attributes

        }

    }

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

#EndRegion  [ Group Information ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''