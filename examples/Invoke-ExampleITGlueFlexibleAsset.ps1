<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueFlexibleAsset script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create a new
        flexible asset type then create or update 5 flexible
        assets in the define organization.

        Any traits are not specify will be deleted. Passing a null value will also delete a trait's value.

        As of 2024-09-28, the flexible asset type endpoint does not support
        deletion so you will have to manually delete the flexible
        asset types from ITGlue

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER OrganizationID
        Defines the ID of the organization to populate example data in

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueFlexibleAsset.ps1 -OrganizationID 12345

        Checks for existing flexible assets and either updates or creates new example flexible assets

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueFlexibleAsset.ps1 -OrganizationID 12345 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing flexible assets and either updates or creates new example flexible assets in bulk, then
        it will prompt to delete all the flexible assets

        API calls are made in bulk so as an example if 5 flexible assets are created then
        only 1 API call is made to create the 5 new flexible assets

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new flexible assets & 1x to delete 5 flexible assets

        Progress information is sent to the console while the script is running
    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#flexible-assets

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

        [Parameter(Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter()]
        [switch]$BulkEdit,

        [Parameter()]
        [switch]$RemoveExamples,

        [Parameter()]
        [switch]$RemoveExamplesConfirm,

        [Parameter()]
        [ValidateRange(1, 100)]
        [int64]$ExamplesToMake = 5

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/4) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName       = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber         = 1
    $ExampleName        = 'ExampleFlexibleAsset'
    $ExampleTypeName    = "$($ExampleName)Type"

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

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Find existing examples"
    $StepNumber++

#Region     [ Find Existing Data ]

    #Check if examples are present
    $CurrentFlexibleAssetType = (Get-ITGlueFlexibleAssetType -FilterName $ExampleTypeName).data
    if ($CurrentFlexibleAssetType) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentFlexibleAssetType| Measure-Object).Count) ] existing flexible asset types"
    }
    else{

        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Creating flexible asset type [ $ExampleTypeName ]"

            #Example Hashtable with new information
            $NewFlexibleAssetTypeHashTable = @{
                type = 'flexible_asset_types'
                attributes = @{
                        name = $ExampleTypeName
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
                            },
                            @{
                                type       = "flexible_asset_fields"
                                attributes = @{
                                    order           = 2
                                    name            = "Example notes"
                                    kind            = "Textbox"
                                    required        = $false
                                    "show-in-list"  = $true
                                    "use-for-title" = $false
                                }
                            }
                        )
                    }
                }
            }

            $NewFlexibleAssetType = New-ITGlueFlexibleAssetType -Data $NewFlexibleAssetTypeHashTable

            $CurrentFlexibleAssetType = (Get-ITGlueFlexibleAssetType -FilterID $NewFlexibleAssetType.data.id).data

    }

    $CurrentFlexibleAssets = (Get-ITGlueFlexibleAsset -FilterFlexibleAssetTypeID $CurrentFlexibleAssetType.id).data

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData  = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleNewData     = [System.Collections.Generic.List[object]]::new()
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleFlexibleAssetName = "$ExampleName-$ExampleNumber"

        $ExistingFlexibleAsset = $CurrentFlexibleAssets | Where-Object {$_.attributes.name -eq $ExampleFlexibleAssetName}

        if ($ExistingFlexibleAsset) {

            $ExampleAssetIsArchived = ($true,$false | Get-Random -Count 1)

            #Simple field updates
            $UpdatedFlexibleAssetHashTable = @{
                type = 'flexible_assets'
                attributes = @{
                    id          = $ExistingFlexibleAsset.id
                    archived    = $ExampleAssetIsArchived
                    traits      = @{
                        'example-field-name'    = $ExampleFlexibleAssetName
                        'example-notes'         = "Updated example notes for this flexible asset - $(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') - Special Characters [ Ä Ö Ü ä ö ü ß ]"
                    }
                }
            }

        }
        else {

            #Example Hashtable with new information
            $NewFlexibleAssetHashTable = @{
                type = 'flexible_assets'
                attributes = @{
                    "organization-id"           = $OrganizationID
                    "flexible-asset-type-id"    = $CurrentFlexibleAssetType.id
                    traits = @{
                        'example-field-name'    = $ExampleFlexibleAssetName
                        'example-notes'         = 'Example notes for this flexible asset - Special Characters [ Ä Ö Ü ä ö ü ß ]'
                    }
                }
            }

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatedFlexibleAssetHashTable) {
                    $ExampleUpdatedData.Add($UpdatedFlexibleAssetHashTable)
                }

                if ($NewFlexibleAssetHashTable) {
                    $ExampleNewData.Add($NewFlexibleAssetHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatedFlexibleAssetHashTable) {

                    if ($ExampleAssetIsArchived) {
                        Write-Host "Updating flexible asset [ $ExampleFlexibleAssetName ] to be archived" -ForegroundColor DarkBlue
                    }
                    else{
                        Write-Host "Updating example flexible asset [ $ExampleFlexibleAssetName ]" -ForegroundColor Yellow
                    }

                    $ITGlueFlexibleAssetReturn = Set-ITGlueFlexibleAsset -ID $ExistingFlexibleAsset.id -Data $UpdatedFlexibleAssetHashTable

                }

                if ($NewFlexibleAssetHashTable) {

                    Write-Host "Creating example flexible asset          [ $ExampleFlexibleAssetName ]" -ForegroundColor Green

                    $ITGlueFlexibleAssetReturn = New-ITGlueFlexibleAsset -OrganizationID $OrganizationID -Data $NewFlexibleAssetHashTable

                }

                #Add return to object list
                if ($ITGlueFlexibleAssetReturn) {
                    $ExampleReturnData.Add($ITGlueFlexibleAssetReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatedFlexibleAssetHashTable   = $null
        $NewFlexibleAssetHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

        #Bulk modifications make a single API call using the array list populated inside the loop
        if ($BulkEdit) {

            if ($ExampleUpdatedData) {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] flexible assets"
                $ExampleReturnData = Set-ITGlueFlexibleAsset -Data $ExampleUpdatedData
            }

            if ($ExampleNewData) {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewData | Measure-Object).Count) ] flexible assets"
                $ExampleReturnData = New-ITGlueFlexibleAsset -OrganizationID $OrganizationID -Data $ExampleNewData
            }

        }

#EndRegion  [ Example Code ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] flexible assets from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    switch ($BulkEdit) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] flexible assets"

            #Stage array lists to store example data
            $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

            foreach ($FlexibleAsset in $ExampleReturnData.data) {

                $DeleteFlexibleAssetHashTable = @{
                    type = 'flexible-assets'
                    attributes = @{ id = $FlexibleAsset.id }
                }

                $ExamplesToDelete.Add($DeleteFlexibleAssetHashTable)

            }

            $DeletedData = Remove-ITGlueFlexibleAsset -Data $ExamplesToDelete -Confirm:$false

        }
        $false  {

            foreach ($FlexibleAsset in $ExampleReturnData) {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting flexible asset [ $($FlexibleAsset.data.attributes.name) ] from [  $($FlexibleAsset.data.attributes.'organization-name') ]"
                $DeletedData = Remove-ITGlueFlexibleAsset -ID $FlexibleAsset.data.id -Confirm:$false
            }

        }
    }

}

    Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - You will have to manually delete the [ $($CurrentFlexibleAssetType.attributes.name) | $($CurrentFlexibleAssetType.id) ] flexible asset type from ITGlue"

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''