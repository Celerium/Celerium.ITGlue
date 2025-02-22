<#
    .SYNOPSIS
        Pulls country information

    .DESCRIPTION
        The Invoke-ExampleITGlueCountry script pulls a
        defined countries information or pulls
        a random countries information

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of country to pull

    .EXAMPLE
        .\Invoke-ExampleITGlueCountry.ps1

        Show a random countries information

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueCountry.ps1 -ID 12345 -Verbose

        Show the defined countries information

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#countries

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
        [string]$ID

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

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Finding country"
    $StepNumber++

#Region     [ Finding country ]

try {

    if ($ID) {

        $ITGlueMeta     = Get-ITGlueCountry -PageNumber 1 -PageSize 1
        $ITGlueCountry  = (Get-ITGlueCountry -ID $ID).data

        if ($null -eq $ITGlueCountry.id) {
            Throw "No country found with an ID of [ $ID ], please verify country ID and try again"
        }

    }
    else{

        $ITGlueMeta     = Get-ITGlueCountry
        $ITGlueCountry  = $ITGlueMeta.data | Get-Random -Count 1

        if ($null -eq $ITGlueCountry.id) {
            Throw "No countries found"
        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found country [ $($ITGlueCountry.attributes.name) - $($ITGlueCountry.id) ]"
    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - There are a total of [ $($ITGlueMeta.meta.'total-count') ] countries in ITGlue"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ITGlueCountry.attributes

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Finding country ]

Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''