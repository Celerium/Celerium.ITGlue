<#
    .SYNOPSIS
        Pulls expiration information

    .DESCRIPTION
        The Invoke-ExampleITGlueExpiration script pulls a
        defined expirations information or pulls
        a random expirations information

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the expiration

    .EXAMPLE
        .\Invoke-ExampleITGlueExpiration.ps1

        Show a random expirations information

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueExpiration.ps1 -ID 12345 -Verbose

        Show the defined expirations information

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#expirations

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
        [ValidateNotNullOrEmpty()]
        [int64]$ID

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/2) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

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

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Finding Expiration"
    $StepNumber++

#Region     [ Finding Expiration ]

try {

    if ($ID) {

        $ITGlueMeta         = Get-ITGlueExpiration -ID $ID
        $ITGlueExpiration   = $ITGlueMeta.data

        if ($null -eq $ITGlueExpiration.id) {
            Throw "No expiration found with an ID of [ $ID ], please verify expiration ID and try again"
        }

    }
    else{

        $ITGlueMeta         = Get-ITGlueExpiration
        $ITGlueExpiration   = $ITGlueMeta.data | Get-Random -Count 1

        if ($null -eq $ITGlueExpiration.id) {
            Throw "No expirations found, please create an ITGlue expiations first and try again"
        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found expiration [ $($ITGlueExpiration.attributes.'resource-name') - $($ITGlueExpiration.id) ] in [ $($ITGlueExpiration.attributes.'organization-name') ]"
    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - There are a total of [ $($ITGlueMeta.meta.'total-count') ] expirations"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ITGlueExpiration.attributes

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Finding Expiration ]

Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''