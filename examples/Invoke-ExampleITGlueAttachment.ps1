<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueAttachment script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new passwords
        with a random number of attachments in a defined organization

        All subsequent runs will then update various items those passwords
        and their attachments

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
        .\Invoke-ExampleITGlueAttachment.ps1 -OrganizationID 12345 -Verbose

        Checks for existing passwords and either updates or creates new example passwords

        Each password with have a random number of attachments associated to them

        API calls are made individually to each password, but attachments are uploaded
        in bulk.

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#attachments

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
    Write-Verbose " - (0/5) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleAttachment'

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

    Write-Verbose " - ($StepNumber/5) - $(Get-Date -Format MM-dd-HH:mm) - Find existing examples"
    $StepNumber++

#Region     [ Find Existing Data ]

    #Check if examples are present
    $CurrentPasswords   = (Get-ITGluePassword -OrganizationID $OrganizationID -Include attachments -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    $CurrentAttachments = foreach ($Password in $CurrentPasswords) {
        if ($null -ne $($Password.Relationships.attachments.data)) {
            Get-ITGluePassword -ID $Password.Id -Include attachments
        }
    }

    if ($CurrentAttachments) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentAttachments| Measure-Object).Count) ] existing attachments"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/5) - $(Get-Date -Format MM-dd-HH:mm) - Staging parent examples"
$StepNumber++

#Region     [ Stage Parent Examples ]

    #Example values
    $ExampleNumber      = 1
    $PasswordCategories = Get-ITGluePasswordCategories

    #Stage array lists to store example data
    $ExampleReturnParentData    = [System.Collections.Generic.List[object]]::new()
    $ExampleNewParentData       = [System.Collections.Generic.List[object]]::new()
    $ExampleUpdatedParentData   = [System.Collections.Generic.List[object]]::new()

    #Loop to create example parent asset to later be used with attachments
    while($ExampleNumber -le $ExamplesToMake) {

        $ExamplePasswordName = "$ExampleName-$ExampleNumber"

        $ExistingPassword = $CurrentPasswords | Where-Object {$_.attributes.name -eq $ExamplePasswordName}

        if ($ExistingPassword) {

            #Simple password field updates
            $UpdatePasswordHashTable = @{
                type        = 'passwords'
                attributes = @{
                    id          = $ExistingPassword.id
                    username    = "AttachmentAdded-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    notes       = "$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') - Updated example notes"
                }
            }

        }
        else {

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

        if ($UpdatePasswordHashTable) {
            $ExampleUpdatedParentData.Add($UpdatePasswordHashTable)
        }

        if ($NewPasswordHashTable) {
            $ExampleNewParentData.Add($NewPasswordHashTable)
        }

        #Clear hashtable's for the next loop
        $UpdatePasswordHashTable    = $null
        $NewPasswordHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    if ($ExampleUpdatedParentData) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedParentData | Measure-Object).Count) ] passwords"
        $ParentDataUpdate = Set-ITGluePasswords -Data $ExampleUpdatedParentData
        $ExampleReturnParentData.Add($ParentDataUpdate) > $null
    }

    if ($ExampleNewParentData) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewParentData | Measure-Object).Count) ] passwords"
        $ParentDataNew = New-ITGluePasswords -OrganizationID $OrganizationID -Data $ExampleNewParentData
        $ExampleReturnParentData.Add($ParentDataNew) > $null
    }

#EndRegion  [ Stage Parent Examples ]

Write-Verbose " - ($StepNumber/5) - $(Get-Date -Format MM-dd-HH:mm) - Populating example attachments"
$StepNumber++

#Region     [ Attachment Data ]

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    $ExampleAttachmentData  = [System.Collections.Generic.List[object]]::new()

    $PasswordsWithAttachments   = $CurrentAttachments
    if ($CurrentAttachments) {
        $PasswordsWithNoAttachments = Compare-Object -ReferenceObject $ExampleReturnParentData.data -DifferenceObject $CurrentAttachments.data -PassThru
    }
    else {$PasswordsWithNoAttachments = $ExampleReturnParentData.data}

    if ($PasswordsWithAttachments) {

        foreach ($Attachment in $PasswordsWithAttachments) {

            #Simple password field updates
            $UpdateAttachmentHashTable = @{
                type        = 'attachments'
                attributes = @{
                    name    = "UpdatedName-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                }
            }

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Updating [ $(($Attachment.included.id | Measure-Object).Count) ] attachment names on [ $($Attachment.data.attributes.name) ]"
            foreach ($id in $Attachment.included.id) {
                $ITGlueAttachmentReturn = Set-ITGlueAttachment -ResourceType passwords -ResourceID $Attachment.data.id -ID $id -Data $UpdateAttachmentHashTable
                $ExampleReturnData.Add($ITGlueAttachmentReturn) > $null
            }

        }

    }

    if ($PasswordsWithNoAttachments) {

        foreach ($Attachment in $PasswordsWithNoAttachments) {

            $MultipleAttachments = ($true,$false | Get-Random -Count 1)

            #Simple new attachment to parent
            $NewAttachmentHashTable = @{
                type        = 'attachments'
                attributes = @{
                    attachment = @{
                        content     = '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'
                        'file_name' = "$ExampleName"
                    }
                }
            }

            if ($MultipleAttachments) {

                $ExampleNumber = 1
                $AttachmentsToUpload = (1..2 | Get-Random -Count 1)

                #Determine how many attachments to upload at once
                while($ExampleNumber -le $AttachmentsToUpload) {
                    $ExampleAttachmentData.Add($NewAttachmentHashTable)
                    $ExampleNumber++
                }
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Creating [ $(($ExampleAttachmentData | Measure-Object).Count) ] attachment for [ $($Attachment.attributes.name) ]"
                $ITGlueAttachmentReturn = New-ITGlueAttachment -ResourceType passwords -ResourceID $Attachment.id -Data $ExampleAttachmentData
                $ExampleReturnData.Add($ITGlueAttachmentReturn) > $null

            }
            else{
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Creating [ 1 ] attachment for [ $($Attachment.attributes.name) ]"
                $ITGlueAttachmentReturn = New-ITGlueAttachment -ResourceType passwords -ResourceID $Attachment.id -Data $NewAttachmentHashTable
                $ExampleReturnData.Add($ITGlueAttachmentReturn) > $null
            }

        }

    }

#EndRegion  [ Attachment Data ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/5) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data.id | Measure-Object).Count) ] attachments from [ $($ExampleReturnParentData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    $CurrentAttachments = foreach ($Parent in $ExampleReturnParentData.data) {

        $ParentAttachments = Get-ITGluePassword -ID $Parent.Id -Include attachments

        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting [ $(($ParentAttachments.included.id | Measure-Object).Count) ] attachments on [ $($ParentAttachments.data.attributes.name) ]"

        $DeleteAttachments = [System.Collections.Generic.List[object]]::new()
        foreach ($Attachment in $ParentAttachments.Included) {
            $DeleteAttachmentHashTable = @{
                type = 'attachments'
                attributes = @{ id = $Attachment.id }
            }
            $DeleteAttachments.Add($DeleteAttachmentHashTable) > $null
        }

        $DeletedData = Remove-ITGlueAttachment -ResourceType passwords -ResourceID $ParentAttachments.data.id -Data $DeleteAttachments -Confirm:$false

    }

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnParentData.data.id | Measure-Object).Count) ] parent passwords from [ $($ExampleReturnParentData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()
    foreach ($Parent in $ExampleReturnParentData.data) {

        $DeletePasswordHashTable = @{
            type = 'passwords'
            attributes = @{ id = $Parent.id }
        }

        $ExamplesToDelete.Add($DeletePasswordHashTable)

    }

    $DeletedData = Remove-ITGluePassword -Data $ExamplesToDelete -Confirm:$false

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/5) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''