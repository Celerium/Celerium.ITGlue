<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueFlexibleAssetType script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 2 new flexible
        asset types in the ITGlue tenant.

        If a flexible asset type already exists then it name is updated

        As of 2024-09-28, the flexible asset type endpoint does not support
        deletion so you will have to manually delete the flexible
        asset types from ITGlue

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueFlexibleAssetType.ps1 -Verbose

        Checks for existing flexible asset types and either updates or creates new example flexible
        asset types

        API calls are made individually, so if 2 examples are made then 2 API calls are made

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#flexible-asset-types

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
        [int64]$ExamplesToMake = 2

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleFlexibleAssetType'

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
    $CurrentFlexibleAssetTypes = (Get-ITGlueFlexibleAssetType -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentFlexibleAssetTypes) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentFlexibleAssetTypes| Measure-Object).Count) ] existing flexible asset types"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData  = [System.Collections.Generic.List[object]]::new()

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleFlexibleAssetTypeName = "$ExampleName-$ExampleNumber"

        $ExistingFlexibleAssetType = $CurrentFlexibleAssetTypes | Where-Object {$_.attributes.name -like "$ExampleFlexibleAssetTypeName*"}

        if ($ExistingFlexibleAssetType) {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Updating flexible asset type [ $($ExistingFlexibleAssetType.attributes.name) | $($ExistingFlexibleAssetType.id) ]"

            #Simple field updates
            $UpdatedFlexibleAssetTypeHashTable = @{
                type = 'flexible-asset-types'
                attributes = @{
                        id   = $ExistingFlexibleAssetType.id
                        name = $ExampleFlexibleAssetTypeName
                        icon = 'magic'
                        description = "Example description updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                }
            }

            $FlexibleAssetTypeReturn = Set-ITGlueFlexibleAssetType -ID $ExistingFlexibleAssetType.id -Data $UpdatedFlexibleAssetTypeHashTable
            $ExampleReturnData.Add($FlexibleAssetTypeReturn) > $null

        }
        else {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - New flexible asset type [ $ExampleFlexibleAssetTypeName ]"

            #Example Hashtable with new information
            $NewFlexibleAssetTypeHashTable = @{
                type = 'flexible-asset-types'
                attributes = @{
                        name = $ExampleFlexibleAssetTypeName
                        icon = 'magic'
                        description = 'This is a example description'
                }
                relationships = @{
                    "flexible-asset-fields" = @{
                        data = @(
                            @{
                                type       = "flexible_asset_fields"
                                attributes = @{
                                    order           = 1
                                    name            = "Example field name"
                                    kind            = "Text"
                                    required        = $true
                                    "show-in-list"  = $true
                                    "use-for-title" = $true
                                }
                            }
                        )
                    }
                }
            }

            $FlexibleAssetTypeReturn = New-ITGlueFlexibleAssetType -Data $NewFlexibleAssetTypeHashTable
            $ExampleReturnData.Add($FlexibleAssetTypeReturn) > $null

        }

        #Clear hashtable's for the next loop
        $UpdatedFlexibleAssetTypeHashTable   = $null
        $NewFlexibleAssetTypeHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

#EndRegion  [ Example Code ]

    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - You will have to manually delete [ $(($ExampleReturnData.data | Measure-Object).Count) ] flexible asset types from ITGlue"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''