<#
    .SYNOPSIS
        Pulls user metrics

    .DESCRIPTION
        The Invoke-ExampleITGlueUserMetric script pulls a
        defined users metrics or a random users metrics

        By default ITGlue returns only the first 50 metrics

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the user to get metrics for

    .PARAMETER FilterDate
        UTC start & end date to get user metrics

        Date ranges longer than a week may be disallowed for performance reasons.

        Example:
            2024-09-23, 2024-09-27

    .EXAMPLE
        .\Invoke-ExampleITGlueUserMetric.ps1 -Verbose

        Pulls a random users metrics from ITGlue and displays the first 50 metrics

        Progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueUserMetric.ps1 -ID 12345 -FilterDate '2024-09-23, 2024-09-27'

        Pulls the defined users metrics from the defined date range

        No progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#accounts-user-metrics-daily

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
        [ValidateNotNullOrEmpty()]
        [string]$FilterDate

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

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting User Metrics"
$StepNumber++

#Region     [ User Metrics ]

    switch ([bool]$FilterDate) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Searching for user metrics in time range [ $($FilterDate) ]"

            $ExampleReturnData =  Get-ITGlueUserMetric -FilterUserID $ITGlueUser.id -FilterDate $FilterDate

        }
        $false  {

            $ExampleReturnData = Get-ITGlueUserMetric -FilterUserID $ITGlueUser.id

        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $( ($ExampleReturnData.data | Measure-Object).Count) ] User Metrics"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData.data

#EndRegion  [ User Metrics ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''