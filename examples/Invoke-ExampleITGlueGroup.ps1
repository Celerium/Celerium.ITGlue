<#
    .SYNOPSIS
        Pulls group information

    .DESCRIPTION
        The Invoke-ExampleITGlueGroup script pulls a
        defined groups information and or also shows
        all members of defined group

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ID
        ID of the group

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .EXAMPLE
        .\Invoke-ExampleITGlueGroup.ps1

        Creates or updates 5 example groups using 5 API calls & the groups
        are NOT deleted when done

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueGroup.ps1 -BulkEdit -RemoveExamples -RemoveExamplesConfirm

        Creates or updates 5 example groups using 1 API call & the groups
        are prompted to be deleted when done

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#groups

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
    $ExampleName    = 'ExampleGroup'

    #Import-Module Celerium.ITGlue -Verbose:$false

    #Setting up ITGlue APIKey & BaseURI
    try {

        if ($APIKey) { Add-ITGlueAPIKey -ApiKey $APIKey }
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
    $CurrentGroups = (Get-ITGlueGroup -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentGroups) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentGroups| Measure-Object).Count) ] existing groups"
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

        $ExampleGroupName = "$ExampleName-$ExampleNumber"

        $ExistingGroup = $CurrentGroups | Where-Object {$_.attributes.name -eq $ExampleGroupName}

        if ($ExistingGroup) {

            #Simple group field updates
            $UpdateGroupHashTable = @{
                type        = 'groups'
                attributes = @{
                    id                      = $ExistingGroup.id
                    name                    = $ExampleGroupName
                    description             = "Here is an example group description [ $ExampleNumber ] - Updated at $(Get-Date -Format MM-dd-HH:mm)"
                    'hide_from_my_glue'     = 'true','false' | Get-Random -Count 1
                }
            }

        }
        else {

            #Example Hashtable with new group information
            $NewGroupHashTable = @{
                type = 'groups'
                attributes = @{
                    name                    = $ExampleGroupName
                    description             = "Here is an example group description [ $ExampleNumber ]"
                    'hide_from_my_glue'     = 'true','false' | Get-Random -Count 1
                }
            }

            Write-Host "Creating example group          [ $ExampleGroupName ]" -ForegroundColor Green
            $ITGlueGroupReturn = New-ITGlueGroup -Data $NewGroupHashTable

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdateGroupHashTable) {
                    $ExampleUpdatedData.Add($UpdateGroupHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdateGroupHashTable) {
                    Write-Host "Updating example group [ $ExampleGroupName ]" -ForegroundColor Yellow
                    $ITGlueGroupReturn = Set-ITGlueGroup -Data $UpdateGroupHashTable
                }

                #Add return to object list
                if ($ITGlueGroupReturn) {
                    $ExampleReturnData.Add($ITGlueGroupReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdateGroupHashTable    = $null
        $NewGroupHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] groups"
            $ExampleReturnData = Set-ITGlueGroup -Data $ExampleUpdatedData
        }

    }
    else{

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] groups" }

    foreach ($Group in $ExampleReturnData.data) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting group [ $($Group.attributes.name) ]"
        $DeletedData = Remove-ITGlueGroup -ID $Group.id -Confirm:$false
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