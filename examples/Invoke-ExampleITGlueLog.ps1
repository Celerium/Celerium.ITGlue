<#
    .SYNOPSIS
        Pulls ITGlue Logs

    .DESCRIPTION
        The Invoke-ExampleITGlueLog script pulls
        recent logs or a random date of logs

        By default only recent logs are returned

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the user to get metrics for

    .PARAMETER SurpriseMe
        UTC start & end date to get user metrics

        Date ranges longer than a week may be disallowed for performance reasons.

        Example:
            2024-09-23, 2024-09-27

    .EXAMPLE
        .\Invoke-ExampleITGlueLog.ps1 -Verbose

        Pulls the most recent logs

        Progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueLog.ps1 -SurpriseMe

        Pulls a random log event

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
        [switch]$SurpriseMe

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

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Finding Logs"
    $StepNumber++

#Region     [ User Metrics ]

    switch ($SurpriseMe) {
        $true   {

            $StartDate      = (Get-Date).AddDays(-30)
            $EndDate        = Get-Date

            $DayRange       = 1..(($EndDate - $StartDate).Days)
            $DaysToAdd      = Get-Random -InputObject $DayRange

            $RandomDate     = ($StartDate.AddDays($DaysToAdd)).ToUniversalTime().ToString('yyyy-MM-dd hh:mm:ss')

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Getting logs starting on [ $RandomDate ]"

            $Log = Get-ITGlueLog -FilterCreatedAt "$RandomDate,*" -PageNumber 1

            if ($Log.data.id) {
                $ExampleReturnData =  $Log.data.attributes | Select-Object -First 1
            }
            else{
                Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - No logs found on [ $RandomDate ]"
            }


        }
        $false  {

            $ExampleReturnData = (Get-ITGlueLog -Sort -created_at -PageNumber 1 -PageSize 50).data.attributes

        }

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $( ($ExampleReturnData | Measure-Object).Count) ] logs"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

#EndRegion  [ User Metrics ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''