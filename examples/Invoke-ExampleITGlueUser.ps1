<#
    .SYNOPSIS
        Pulls user Information and or changes a users avatar

    .DESCRIPTION
        The Invoke-ExampleITGlueUser script pulls a
        defined users information and or a changes their
        avatar to a simple alphabet icon

        By default only users that do NOT have an avatar
        will have their avatar changed

        A users avatar is based on the first letter of their
        first name

        Fun fact, ITGlues default avatar which is a simple
        first letter of the users first and last name is always rendered
        even when an avatar is uploaded. This can be seen by uploading
        a transparent PNG ;)

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the user

    .PARAMETER ChangeAvatar
        Changes the users avatar

        Depends on the icons in the "UserIcons" folder

    .EXAMPLE
        .\Invoke-ExampleITGlueUser.ps1 -Verbose

        Pulls a random users information from ITGlue

        Progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueUser.ps1 -ID 12345 -ChangeAvatar

        Pulls the defined users information and changes their avatar if it is empty

        No progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#accounts-users

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
        [switch]$ChangeAvatar

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

        if ($ChangeAvatar) {

            $Path = Join-Path -Path $PSScriptRoot -ChildPath UserIcons

            if (Test-Path -Path $Path) { $IconPath = $Path }
            else{ Throw "The UserIcons folder was not found - [ $Path ]" }

        }

    }
    catch {
        Write-Error $_
        exit 1
    }

#EndRegion  [ Prerequisites ]

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Finding User"
    $StepNumber++

#Region     [ Find Existing User ]

try {

    if ($ID) {
        $ITGlueUser = (Get-ITGlueUser -FilterID $ID).data

        if ($null -eq $ITGlueUser.id) {
            Throw "No user found with an ID of [ $ID ], please verify user ID and try again"
        }

    }
    else{
        $ITGlueUser = (Get-ITGlueUser).data | Get-Random -Count 1

        if ($null -eq $ITGlueUser.id) {
            Throw "No users found, please create an ITGlue user first and try again"
        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found user [ $($ITGlueUser.attributes.name) - $($ITGlueUser.id) ]"

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting User Information"
$StepNumber++

#Region     [ User Information ]

    switch ([bool]$ChangeAvatar) {
        $true   {

            if ([string]::IsNullOrEmpty($ITGlueUser.attributes.avatar)) {

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Changing users avatar"

                $FirstLetter    = ($ITGlueUser.attributes.'first-name').Substring(0,1)

                $UserIcon       = Join-Path -Path $IconPath -ChildPath "$FirstLetter.jpg"
                $Base64Icon     = [convert]::ToBase64String((Get-Content -Path $UserIcon -encoding byte))

                $AvatarHashTable = @{
                    type        = 'users'
                    attributes = @{
                        avatar = @{
                            content     = $Base64Icon
                            'file_name' = "Example-Avatar"
                        }
                    }
                }

                Set-ITGlueUser -ID $ITGlueUser.id -Data $AvatarHashTable -Confirm > $null
                $ExampleReturnData          = (Get-ITGlueUser -ID $ITGlueUser.id).data.attributes

            }
            else {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Skipping - User [ $($ITGlueUser.attributes.name) ] already has an avatar"
                $ExampleReturnData = $ITGlueUser.attributes
            }

        }
        $false  {

            $ExampleReturnData = $ITGlueUser.attributes

        }

    }

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

#EndRegion  [ User Information ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''