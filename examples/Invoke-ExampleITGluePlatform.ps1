<#
    .SYNOPSIS
        Pulls an ITGlue Platform

    .DESCRIPTION
        The Invoke-ExampleITGlueRegion script pulls a
        defined or random ITGlue platform

        By default a random platform is pulled

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the platform

    .EXAMPLE
        .\Invoke-ExampleITGluePlatform.ps1 -Verbose

        Pulls a random platform from ITGlue and displays results

        Progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGluePlatform.ps1 -ID 12345

        Pulls the defined platform and displays the results

        No progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#platforms

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

    #Setting up ITGlue APIKey & BaseURI
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

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Finding Platform"
    $StepNumber++

#Region     [ Main Code ]

try {

    if ($ID) {

        $ExampleReturnData = (Get-ITGluePlatform -ID $ID).data

        if ($null -eq $ExampleReturnData.id) {
            Throw "No platform found with an ID of [ $ID ], please verify platform ID and try again"
        }

    }
    else{

        $TotalPlatforms     = (Get-ITGluePlatform -PageSize 1).meta.'total-count'
        $ExampleReturnData  = (Get-ITGluePlatform -ID $( 1..$TotalPlatforms | Get-Random -Count 1 )).data

        if ($null -eq $ExampleReturnData.id) {
            Throw "No platform found, please verify ITGlue platforms and try again"
        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found platform [ $($ExampleReturnData.attributes.name) - $($ExampleReturnData.id) ]"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Main Code ]

Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''