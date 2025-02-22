<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueRelatedItem script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create new passwords
        in a defined organization and randomly relate items to each other

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER OrganizationID
        Defines the ID of the organization to populate example data in

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueRelatedItem.ps1 -OrganizationID 12345

        Checks for existing passwords and related items and either updates or creates new
        passwords and related items

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueRelatedItem.ps1 -OrganizationID 12345 -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing passwords and related items and either updates or creates new
        passwords and related items, then it will prompt to delete all the passwords
        and related items

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#related-items-bulk-destroy

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
    $ExampleName    = 'ExamplePassword'

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
    $CurrentPasswords = (Get-ITGluePassword -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentPasswords) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentPasswords| Measure-Object).Count) ] existing passwords"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Passwords ]

    #Example values
    $ExampleNumber      = 1
    $PasswordCategories = Get-ITGluePasswordCategories

    #Stage array lists to store example data
    $ExampleNewPasswords    = [System.Collections.Generic.List[object]]::new()

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExamplePasswordName = "$ExampleName-$ExampleNumber"

        $ExistingPassword = $CurrentPasswords | Where-Object {$_.attributes.name -eq $ExamplePasswordName}

        if (-not $ExistingPassword) {

            #Example Hashtable with new password information
            $NewPasswordHashTable = @{
                type = 'passwords'
                attributes = @{
                        name                    = $ExamplePasswordName
                        password_category_id    = $($PasswordCategories.data.id | Get-Random -Count 1)
                        username                = "ExampleUser-$ExampleNumber"
                        password                = New-Guid
                        url                     = "https://example.com"
                        notes                   = "Here are some example notes"
                }
            }

        }

        #If bulk editing then add hashtable into an array list to be used later outside the loop
        if ($NewPasswordHashTable) {
            $ExampleNewPasswords.Add($NewPasswordHashTable)
        }

        #Clear hashtable's for the next loop
        $NewPasswordHashTable = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop

    if ($ExampleNewPasswords) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewPasswords | Measure-Object).Count) ] passwords"
        $ExamplePasswordReturn = New-ITGluePasswords -OrganizationID $OrganizationID -Data $ExampleNewPasswords
    }

#EndRegion  [ Example Passwords ]

#Region     [ Example Relate Items ]

    #Stage array lists to store example data
    $ExampleRelatedItems    = [System.Collections.Generic.List[object]]::new()

    $KnownPasswords = [System.Collections.Generic.List[object]]::new()
    if ($CurrentPasswords) {
        foreach ($item in $CurrentPasswords){
            $KnownPasswords.add($item) > $null
        }
    }

    if ($ExamplePasswordReturn) {
        foreach ($item in $ExamplePasswordReturn) {
            $KnownPasswords.add($item.data) > $null
        }
    }

    $CurrentRelatedItems = foreach ($Password in $KnownPasswords.id) {
        Get-ITGluePassword -ID $Password -Include related_items
    }

    foreach ($Password in $CurrentRelatedItems) {

        if ($null -eq $Password.included.id) {

            $RandomRelate = $KnownPasswords | Where-Object {$_.id -ne $Password.data.id} | Get-Random -Count 1

            $NewHashTable = @{
                type = 'related_items'
                attributes = @{
                    'destination_type'  = 'Password'
                    'destination_id'    = $RandomRelate.id
                    notes               = "New example notes"
                }
            }

            Write-Host "New related item from [ $($Password.data.attributes.Name) ] to [ $($RandomRelate.attributes.name) ]" -ForegroundColor DarkGreen
            $ITGlueRelatedReturn = New-ITGlueRelatedItem -ResourceType passwords -ResourceID $Password.data.id -Data $NewHashTable -ErrorVariable NewRelatedError

            if ($ITGlueRelatedReturn) {$ExampleRelatedItems.Add($ITGlueRelatedReturn) > $null}

            if ($NewRelatedError.Exception -like "*422*"){
                Write-Host "Example Issue - Related item cannot be related to an item its already related to - [ $($Password.data.attributes.Name) ] | [ $($RandomRelate.attributes.name) ]" -ForegroundColor DarkCyan
            }

        }
        else{

            foreach ($RelatedItem in $Password.included.id) {

                $UpdatedHashTable = @{
                    type = 'related_items'
                    attributes = @{
                        #Id      = $$RelatedItem
                        notes   = "Updated notes - $(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    }
                }

                Write-Host "Updating related item - [ $RelatedItem ] on [ $($Password.data.attributes.Name) ]" -ForegroundColor DarkYellow
                $ITGlueRelatedReturn = Set-ITGlueRelatedItem -ResourceType passwords -ResourceID $Password.data.id -ID $RelatedItem -Data $UpdatedHashTable

                if ($ITGlueRelatedReturn) {$ExampleRelatedItems.Add($ITGlueRelatedReturn) > $null}

            }

        }

    }

#EndRegion  [ Example Relate Items ]

#Region     [ Example Cleanup ]

if ($RemoveExamples) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($ExampleRelatedItems) {

        if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleRelatedItems.data.id | Measure-Object).Count) ] related items" }

        foreach ($RelatedItem in $ExampleRelatedItems.data) {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting [ $($RelatedItem.id) ] from [ $($RelatedItem.attributes.'destination-name') ]"

            $DeleteRelatedHashTable = @{
                type = 'related_items'
                attributes = @{ id = $RelatedItem.id }
            }

            $DeletedData = Remove-ITGlueRelatedItem -ResourceType passwords -ResourceID $RelatedItem.attributes.'destination-id' -Data $DeleteRelatedHashTable -Confirm:$false -ErrorVariable DeleteRelatedError

            if ($DeleteRelatedError.Exception -like "*URI not found*"){
                Write-Host "Example Issue - Deleting a related item from one resource deletes it from its related resource" -ForegroundColor DarkCyan
            }

        }

    }

    if ($KnownPasswords) {

        if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($KnownPasswords.id | Measure-Object).Count) ] passwords" }

        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($KnownPasswords.id | Measure-Object).Count) ] passwords"

        #Stage array lists to store example data
        $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

        foreach ($Password in $KnownPasswords) {

            $DeletePasswordHashTable = @{
                type = 'passwords'
                attributes = @{ id = $Password.id }
            }

            $ExamplesToDelete.Add($DeletePasswordHashTable)

        }

        $DeletedData = Remove-ITGluePassword -Data $ExamplesToDelete -Confirm:$false

    }

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleRelatedItems -Scope Global -Force

    $ExampleRelatedItems

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''