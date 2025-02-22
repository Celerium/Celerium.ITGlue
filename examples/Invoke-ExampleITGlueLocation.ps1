<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueLocation script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new locations
        in a defined organization. All subsequent runs will then update
        various fields of those locations

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
        .\Invoke-ExampleITGlueLocation.ps1 -OrganizationID 12345

        Checks for existing locations and either updates or creates new example locations

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueLocation.ps1 -OrganizationID 12345 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing locations and either updates or creates new example locations in bulk, then
        it will prompt to delete all the locations

        API calls are made in bulk so as an example if 5 locations are created then
        only 1 API call is made to create the 5 new locations

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new locations & 1x to delete 5 locations

        Progress information is sent to the console while the script is running


    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#locations

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

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleLocation'

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
    $CurrentLocations = (Get-ITGlueLocation -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentLocations) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentLocations| Measure-Object).Count) ] existing locations"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
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

        $ExampleLocationName = "$ExampleName-$ExampleNumber"

        $ExistingLocation = $CurrentLocations | Where-Object {$_.attributes.name -eq $ExampleLocationName}

        if ($ExistingLocation) {

            #Simple location field updates
            $UpdateLocationHashTable = @{
                type        = 'locations'
                attributes = @{
                    id          = $ExistingLocation.id
                    'address_1' = 'Updated-123 Address #1'
                    'address_2' = 'Updated-123 Address #2'
                    'city'      = 'Updated-Example City'
                    notes       = "$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') - Updated example notes"
                }
            }

        }
        else {

            #Example Hashtable with new location information
            $NewLocationHashTable = @{
                type = 'locations'
                attributes = @{
                        'organization_id'   = $OrganizationID
                        'name'              = $ExampleLocationName
                        'address_1'         = '123 Address #1'
                        'address_2'         = '123 Address #2'
                        'city'              = 'Example City'
                        'postal_code'       = '12345'
                        'phone'             = '123-456-7890'
                        'fax'               = '987-654-3210'
                        'notes'             = "Here are some example notes"
                }
            }

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdateLocationHashTable) {
                    $ExampleUpdatedData.Add($UpdateLocationHashTable)
                }

                if ($NewLocationHashTable) {
                    $ExampleNewData.Add($NewLocationHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdateLocationHashTable) {

                    Write-Host "Updating example location [ $ExampleLocationName ]" -ForegroundColor Yellow
                    $ITGlueLocationReturn = Set-ITGlueLocation -OrganizationID $OrganizationID -ID $ExistingLocation.id -Data $UpdateLocationHashTable

                }

                if ($NewLocationHashTable) {

                    if ($ExampleLocationIsArchived) {
                        Write-Host "Creating example archived location [ $ExampleLocationName ]" -ForegroundColor DarkBlue
                    }
                    else{
                        Write-Host "Creating example location          [ $ExampleLocationName ]" -ForegroundColor Green
                    }

                    $ITGlueLocationReturn = New-ITGlueLocation -OrganizationID $OrganizationID -Data $NewLocationHashTable

                }

                #Add return to object list
                if ($ITGlueLocationReturn) {
                    $ExampleReturnData.Add($ITGlueLocationReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdateLocationHashTable    = $null
        $NewLocationHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] locations"
            $ExampleReturnData = Set-ITGlueLocation -Data $ExampleUpdatedData
        }

        if ($ExampleNewData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewData | Measure-Object).Count) ] locations"
            $ExampleReturnData = New-ITGlueLocation -OrganizationID $OrganizationID -Data $ExampleNewData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] locations from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    switch ($BulkEdit) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] locations"

            #Stage array lists to store example data
            $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

            foreach ($Location in $ExampleReturnData.data) {

                $DeleteLocationHashTable = @{
                    type = 'locations'
                    attributes = @{ id = $Location.id }
                }

                $ExamplesToDelete.Add($DeleteLocationHashTable)

            }

            $DeletedData = Remove-ITGlueLocation -Data $ExamplesToDelete -Confirm:$false

        }
        $false  {

            foreach ($Location in $ExampleReturnData) {

                $DeleteLocation = @{
                    type = 'locations'
                    attributes = @{ id = $Location.data.id }
                }

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting location [ $($Location.data.attributes.name) ] from [  $($Location.data.attributes.'organization-name') ]"
                $DeletedData = Remove-ITGlueLocation -Data $DeleteLocation -Confirm:$false
            }

        }
    }

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''