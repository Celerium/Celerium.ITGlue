<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueModel script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 3 new models
        under an example manufacturer. All subsequent runs will then update
        the names of the models

        As of 2024-09-28, the models endpoint does not have a deletion
        method, so any models created will have to be manually deleted

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueModel.ps1

        Checks for existing models and either updates or creates new example models

        API calls are made individually, so if 3 examples are made then 3 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueModel.ps1 -BulkEdit -Verbose

        Checks for existing models and either updates or creates new example models in bulk

        API calls are made in bulk so as an example if 3 examples are created then
        only 1 API call is made to create the 3 new/updated examples

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#models

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
        [switch]$BulkEdit,

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
    $ExampleName                = 'ExampleModel'
    $ExampleManufacturerName    = 'ExampleManufacturer'

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
    $CurrentManufacturer = (Get-ITGlueManufacturer -FilterName $ExampleManufacturerName).data
    if ($CurrentManufacturer) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentManufacturer| Measure-Object).Count) ] existing manufacturer"
    }
    else{

        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Creating example manufacturer [ $ExampleManufacturerName ]"

        $ManufacturerHashTable = @{
            type        = 'manufacturers'
            attributes = @{
                name = $ExampleManufacturerName
            }
        }

        $CurrentManufacturer = New-ITGlueManufacturer -Data $ManufacturerHashTable

    }

    $CurrentModels = (Get-ITGlueModel -ManufacturerID $CurrentManufacturer.id -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentModels) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentModels| Measure-Object).Count) ] existing models"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleNewData     = [System.Collections.Generic.List[object]]::new()
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleModelName = "$ExampleName-$ExampleNumber"

        $ExistingModel = $CurrentModels | Where-Object {$_.attributes.name -like "$ExampleModelName*"}

        if ($ExistingModel) {

            #Simple field updates
            $UpdatedHashTable = @{
                type        = 'models'
                attributes = @{
                    'id'                = $ExistingModel.id
                    name                = "$ExampleModelName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    'manufacturer-id'   = $CurrentManufacturer.id
                }
            }

        }
        else {

            #Example Hashtable with new information
            $NewHashTable = @{
                type        = 'models'
                attributes = @{
                    name                = $ExampleModelName
                    'manufacturer-id'   = $CurrentManufacturer.id
                }
            }

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatedHashTable) {
                    $ExampleUpdatedData.Add($UpdatedHashTable)
                }

                if ($NewHashTable) {
                    $ExampleNewData.Add($NewHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatedHashTable) {

                    Write-Host "Updating example model [ $($ExistingModel.attributes.name) ]" -ForegroundColor Yellow
                    $ITGlueModelReturn = Set-ITGlueModel -ManufacturerID $CurrentManufacturer.id -ID $ExistingModel.id -Data $UpdatedHashTable

                }

                if ($NewHashTable) {

                    Write-Host "Creating example model          [ $($ExistingModel.attributes.name) ]" -ForegroundColor Green
                    $ITGlueModelReturn = New-ITGlueModel -ManufacturerID $CurrentManufacturer.id -Data $NewHashTable

                }

                #Add return to object list
                if ($ITGlueModelReturn) {
                    $ExampleReturnData.Add($ITGlueModelReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatedHashTable   = $null
        $NewHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        Set-Variable -Name Test_ExampleUpdatedData -Value $ExampleUpdatedData -Scope Global -Force

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] models"
            $ExampleReturnData = Set-ITGlueModel -Data $ExampleUpdatedData
        }

        if ($ExampleNewData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewData | Measure-Object).Count) ] models"
            $ExampleReturnData = New-ITGlueModel -ManufacturerID $CurrentManufacturer.id -Data $ExampleNewData
        }

    }

#EndRegion  [ Example Code ]

    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - You will have to manually delete [ $(($CurrentManufacturer | Measure-Object).Count) ] manufacturers from ITGlue"
    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - You will have to manually delete [ $(($ExampleReturnData.data | Measure-Object).Count) ] models from ITGlue"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"



Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''