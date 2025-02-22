<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueOrganization script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new organizations
        in a defined organization. All subsequent runs will then update
        various fields of those organizations

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueOrganization.ps1

        Checks for existing organizations and either updates or creates new example organizations

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueOrganization.ps1 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing organizations and either updates or creates new example organizations in bulk, then
        it will prompt to delete all the created organizations

        API calls are made in bulk so as an example if 5 examples are created then
        only 1 API call is made to create the 5 new organizations

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new organizations & 1x to delete 5 organizations

        Note: Organizations cannot be bulk created

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#organizations

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
    $ExampleName    = 'ExampleOrganization'

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
    $CurrentOrganizations = (Get-ITGlueOrganization -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentOrganizations) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentOrganizations| Measure-Object).Count) ] existing organizations"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber          = 1
    $OrganizationTypes      = Get-ITGlueOrganizationType
    $OrganizationStatues    = Get-ITGlueOrganizationStatus

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleNewData     = [System.Collections.Generic.List[object]]::new()
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleOrganizationName = "$ExampleName-$ExampleNumber"

        $ExistingOrganization = $CurrentOrganizations | Where-Object {$_.attributes.name -eq $ExampleOrganizationName}

        if ($ExistingOrganization) {

            #Simple field updates
            $UpdatedOrganizationHashTable = @{
                type        = 'organizations'
                attributes = @{
                    Id                          = $ExistingOrganization.id
                    'organization-type-id'      = ($OrganizationTypes.data.id | Get-Random -Count 1)
                    'organization-status-id'    = ($OrganizationStatues.data.id | Get-Random -Count 1)
                    'quick-notes'               = "$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') - Updated example notes"
                }
            }

        }
        else {

            #Example Hashtable with new organization information
            $NewOrganizationHashTable = @{
                type = 'organizations'
                attributes = @{
                        name                        = $ExampleOrganizationName
                        'organization-type-id'      = ($OrganizationTypes.data.id | Get-Random -Count 1)
                        'organization-status-id'    = ($OrganizationStatues.data.id | Get-Random -Count 1)
                        'quick-notes'               = "New example notes"
                }
            }

            Write-Host "Creating example organization          [ $ExampleOrganizationName ]" -ForegroundColor Green
            $ITGlueOrganizationReturn = New-ITGlueOrganization -Data $NewOrganizationHashTable

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatedOrganizationHashTable) {
                    $ExampleUpdatedData.Add($UpdatedOrganizationHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatedOrganizationHashTable) {

                    Write-Host "Updating example organization [ $ExampleOrganizationName ]" -ForegroundColor Yellow
                    $ITGlueOrganizationReturn = Set-ITGlueOrganization -ID $ExistingOrganization.id -Data $UpdatedOrganizationHashTable

                }

                #Add return to object list
                if ($ITGlueOrganizationReturn) {
                    $ExampleReturnData.Add($ITGlueOrganizationReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatedOrganizationHashTable   = $null
        $NewOrganizationHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] organizations"
            $ExampleReturnData = Set-ITGlueOrganization -Data $ExampleUpdatedData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] organizations" }

    switch ($BulkEdit) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] organizations"

            #Stage array lists to store example data
            $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

            foreach ($Organization in $ExampleReturnData.data) {

                $DeleteOrganizationHashTable = @{
                    type = 'organizations'
                    attributes = @{ id = $Organization.id }
                }

                $ExamplesToDelete.Add($DeleteOrganizationHashTable)

            }

            $DeletedData = Remove-ITGlueOrganization -Data $ExamplesToDelete -Confirm:$false

        }
        $false  {

            foreach ($Organization in $ExampleReturnData) {

                $DeleteOrganization = @{
                    type = 'organizations'
                    attributes = @{ id = $Organization.data.id }
                }

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting organization [ $($Organization.data.attributes.name) ]"
                $DeletedData = Remove-ITGlueOrganization -Data $DeleteOrganization -Confirm:$false
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