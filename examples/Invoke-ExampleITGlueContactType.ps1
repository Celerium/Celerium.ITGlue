<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueContactType script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 3 new contact
        types in the ITGlue tenant.

        If a contact type already exists then it name is updated

        As of 2024-09-28, the contact type endpoint does not support
        deletion so you will have to manually delete the contact
        types from ITGlue

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueContactType.ps1 -Verbose

        Checks for existing contact types and either updates or creates new example contact
        types

        API calls are made individually, so if 3 examples are made then 3 API calls are made

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#contact-types

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
        [string]$APIKey,

        [Parameter()]
        [string]$APIUri,

        [Parameter()]
        [ValidateRange(1, 5)]
        [int64]$ExamplesToMake = 3

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleContactType'

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

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Find existing examples"
    $StepNumber++

#Region     [ Find Existing Data ]

    #Check if examples are present
    $CurrentContactTypes = (Get-ITGlueContactType -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentContactTypes) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentContactTypes| Measure-Object).Count) ] existing contact types"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleContactTypeName = "$ExampleName-$ExampleNumber"

        $ExistingContactType = $CurrentContactTypes | Where-Object {$_.attributes.name -like "$ExampleContactTypeName*"}

        if ($ExistingContactType) {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Updating contact type [ $($ExistingContactType.attributes.name) | $($ExistingContactType.id) ]"

            #Simple field updates
            $UpdatedContactTypeHashTable = @{
                type        = 'contact-types'
                attributes = @{
                    name = "$ExampleContactTypeName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                }
            }

            $ContactTypeReturn = Set-ITGlueContactType -ID $ExistingContactType.id -Data $UpdatedContactTypeHashTable
            $ExampleReturnData.Add($ContactTypeReturn) > $null

        }
        else {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - New contact type [ $ExampleContactTypeName ]"

            #Example Hashtable with new information
            $NewContactTypeHashTable = @{
                type        = 'contact-types'
                attributes = @{
                    name = $ExampleContactTypeName
                }
            }

            $ContactTypeReturn = New-ITGlueContactType -Data $NewContactTypeHashTable
            $ExampleReturnData.Add($ContactTypeReturn) > $null

        }

        #Clear hashtable's for the next loop
        $UpdatedContactTypeHashTable   = $null
        $NewContactTypeHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

#EndRegion  [ Example Code ]

    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - You will have to manually delete [ $(($ExampleReturnData.data | Measure-Object).Count) ] contact types from ITGlue"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''