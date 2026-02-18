<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueChecklist script updates example
        data using the various methods available to an endpoint
        as well as delete the defined checklists (if defined to)

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ChecklistID
        A valid checklist id

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueChecklist.ps1 -ChecklistID 12345

        Checks for existing checklist and updates new example checklist

        API calls are made individually, so if 3 examples are updated then 3 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueChecklist.ps1 -ChecklistID 12345,56789 -BulkEdit -Verbose

        Checks for existing checklists and updates new example checklists in bulk

        API calls are made in bulk so as an example if 3 examples are updated then
        only 1 API call is made to update the 3 examples

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#checklists

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
        [int64]$OrganizationID,

        [Parameter()]
        [int64[]]$ChecklistID,

        [Parameter()]
        [switch]$BulkEdit,

        [Parameter()]
        [switch]$RemoveExamples,

        [Parameter()]
        [switch]$RemoveExamplesConfirm

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleChecklist'

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
    $ITGlueChecklists = [System.Collections.Generic.List[object]]::new()

    foreach ($ID in $ChecklistID) {
        $data = (Get-ITGlueChecklist -FilterID $ID).Data
        if ($data){ $ITGlueChecklists.Add($data) > $null }
    }

    if ($ITGlueChecklists) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($ITGlueChecklists| Measure-Object).Count) ] existing Checklist"
    }
    else {
        throw "No ITGlue checklists found matching IDs [ $($ChecklistID -join ',') ] "
        exit 1
    }


#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

Set-Variable Test_ITGlueChecklists -Value $ITGlueChecklists -Scope Global -Force

#Region     [ Example Code ]

    $ExampleNumber = 1

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    if ($BulkEdit) {

        foreach ($ITGlueChecklist in $ITGlueChecklists) {

            $UpdatedHashTable = @{
                type       = 'checklists'
                attributes = @{
                    'id'            = $ITGlueChecklist.id
                    name            = "$ExampleName-$ExampleNumber-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    'description'   = "This description was update at [ $(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') ]"
                    'due_date'      = ([datetime]::new((Get-Random -Min (Get-Date).Ticks -Max (Get-Date).AddYears(1).Ticks))).ToString("yyyy-MM-dd")
                }
            }

            $ExampleUpdatedData.Add($UpdatedHashTable) > $null
            $ExampleNumber++

        }

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] checklists"
            $ExampleReturnData = Set-ITGlueChecklist -Data $ExampleUpdatedData
        }

    }
    else{

        foreach ($ITGlueChecklist in $ITGlueChecklists) {

            $UpdatedHashTable = @{
                type       = 'checklists'
                attributes = @{
                    'id'            = $ITGlueChecklist.id
                    name            = "$ExampleName-$ExampleNumber-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    'description'   = "This description was update at [ $(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') ]"
                    'due_date'      = ([datetime]::new((Get-Random -Min (Get-Date).Ticks -Max (Get-Date).AddYears(1).Ticks))).ToString("yyyy-MM-dd")
                }
            }

            Write-Host "Updating example checklist [ $($ITGlueChecklist.attributes.name) ]" -ForegroundColor Yellow
            $ITGlueChecklistReturn = Set-ITGlueChecklist -ID $ITGlueChecklist.id -Data $UpdatedHashTable

            #Add return to object list
            if ($ITGlueChecklistReturn) {
                $ExampleReturnData.Add($ITGlueChecklistReturn)
            }

            $ExampleNumber++

        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data.id | Measure-Object).Count) ] checklists from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data.id | Measure-Object).Count) ] checklists"

    #Stage array lists to store example data
    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

    foreach ($Checklist in $ExampleReturnData.data) {

        $DeleteChecklistHashTable = @{
            type = 'checklists'
            attributes = @{ id = $Checklist.id }
        }

        $ExamplesToDelete.Add($DeleteChecklistHashTable)

    }

    $DeletedData = Remove-ITGlueChecklist -Data $ExamplesToDelete -Confirm:$false

}

#EndRegion  [ Example Cleanup ]

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''