<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGluePassword script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new password folders
        in a defined organization. All subsequent runs will then update
        various fields of those password folders

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
        .\Invoke-ExampleITGluePassword.ps1 -OrganizationID 12345

        Checks for existing password folders and either updates or creates new example password folders

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGluePassword.ps1 -OrganizationID 12345 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing password folders and either updates or creates new example password folders in bulk, then
        it will prompt to delete all the password folders

        API calls are made in bulk so as an example if 5 password folders are created then
        only 1 API call is made to create the 5 new password folders

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new password folders & 1x to delete 5 password folders

        Progress information is sent to the console while the script is running


    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#password-folders

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
    $ExampleName    = 'ExamplePasswordFolder'

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
    $CurrentPasswordFolders = (Get-ITGluePasswordFolder -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentPasswordFolders) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentPasswordFolders| Measure-Object).Count) ] existing password folders"
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
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExamplePasswordFolderName = "$ExampleName-$ExampleNumber"

        $ExistingPasswordFolder = $CurrentPasswordFolders | Where-Object {$_.attributes.name -like "$ExamplePasswordFolderName*"}

        if ($ExistingPasswordFolder) {

            #Simple password field updates
            $UpdatePasswordFolderHashTable = @{
                type        = 'password_folders'
                attributes = @{
                    id          = $ExistingPasswordFolder.id
                    Name        = "$ExamplePasswordFolderName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    restricted  = 'true','false' | Get-Random -Count 1
                }
            }

        }
        else {

            #Example Hashtable with new password information
            $NewPasswordFolderHashTable  = @{
                type = 'password_folders'
                attributes = @{
                        name                    = $ExamplePasswordFolderName
                        restricted              = 'true','false' | Get-Random -Count 1
                }
            }

            Write-Host "Creating example password          [ $ExamplePasswordFolderName ]" -ForegroundColor Green
            $ExampleReturnData = New-ITGluePasswordFolder -OrganizationID $OrganizationID -Data $NewPasswordFolderHashTable

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatePasswordFolderHashTable) {
                    $ExampleUpdatedData.Add($UpdatePasswordFolderHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatePasswordFolderHashTable) {
                    Write-Host "Updating example password [ $ExamplePasswordFolderName ]" -ForegroundColor Yellow
                    $ITGluePasswordFolderReturn = Set-ITGluePasswordFolder -OrganizationID $OrganizationID -ID $ExistingPasswordFolder.id -Data $UpdatePasswordFolderHashTable
                }

                #Add return to object list
                if ($ITGluePasswordFolderReturn) {
                    $ExampleReturnData.Add($ITGluePasswordFolderReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatePasswordFolderHashTable  = $null
        $NewPasswordFolderHashTable     = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] password folders"
            $ExampleReturnData = Set-ITGluePasswordFolder -Data $ExampleUpdatedData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] password folders from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] password folders"

    #Stage array lists to store example data
    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

    foreach ($Folder in $ExampleReturnData.data) {

        $DeletePasswordFolderHashTable = @{
            type = 'password_folders'
            attributes = @{ id = $Folder.id }
        }

        $ExamplesToDelete.Add($DeletePasswordFolderHashTable)

    }

    $DeletedData = Remove-ITGluePasswordFolder -OrganizationID $OrganizationID -Data $ExamplesToDelete -Confirm:$false
}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''