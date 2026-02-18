<#
    .SYNOPSIS
        Edits document information

    .DESCRIPTION
        The Invoke-ExampleITGlueDocument script edits
        a defined document

        By default this script will update the following
        document fields

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
        .\Invoke-ExampleITGlueDocument.ps1 OrganizationID 12345

        Creates 5 example documents and adds an image to

        Changes are made individual so in this case 2 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueDocument.ps1 OrganizationID 12345 -BulkEdit -Verbose

        Edits the Name,Archived,Restricted fields for 5 example documents

        Changes are made in bulk so in this case 1 API call is made

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#documentimages

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
        [ValidateNotNullOrEmpty()]
        [string]$APIKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
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
    $ExampleName    = 'ExampleDocumentImage'

    Import-Module Celerium.ITGlue -Verbose:$false

    #Setting up ITGlue APIKey, BaseURI & Validate "UserIcons" folder Path
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

    $CurrentDocuments = [System.Collections.Generic.List[object]]::new()
    #Check if examples are present
    $CurrentDocuments = (Get-ITGlueDocument -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}

    if ($CurrentDocuments) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentDocuments| Measure-Object).Count) ] existing documents"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate Examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData          = [System.Collections.Generic.List[object]]::new()

    #ITGlue Base64 Logo
    $ITGlueBase64Logo       = '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'
    $ITGlueBase64LogoInvert = "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"

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $Section = 'Document::Text','Document::Gallery' | Get-Random -Count 1
        switch ($Section) {
            'Document::Text'    { $ImageType = 'document' }
            'Document::Gallery' { $ImageType = 'gallery' }
        }

        $ExampleDocumentName        = "$ExampleName-$ExampleNumber"
        $ExampleDocumentSectionName = "$ExampleName-$Section-$ExampleNumber"

        $ExistingDocument = $CurrentDocuments | Where-Object {$_.attributes.name -like "$ExampleDocumentName*"}

        if ($ExistingDocument) {

            $ExistingDocumentSection = (Get-ITGlueDocumentSection -DocumentId $ExistingDocument.id).data

            switch ($ExistingDocumentSection.attributes.'resource-type') {
                'Document::Text'    {

                    #Update Document Image
                    $UpdatedDocumentImageHashTable = @{
                        "type" = "document-images"
                            "attributes"= @{
                                "target" = @{
                                    "type"  = 'document'
                                    "id"    = $ExistingDocument.id
                                }
                                "image" = @{
                                    "content"   = $ITGlueBase64LogoInvert
                                    "file-name" = "ITGlueLogo-$ExampleNumber-Updated.png"
                                }
                            }
                    }

                    Write-Host "Updating example [ Type | $ImageType ] image" -ForegroundColor Green
                    $UpdatedITGlueDocumentImage = (New-ITGlueDocumentImage -Data $UpdatedDocumentImageHashTable).data

                    #Update Document Section
                    $UpdatedDocumentSectionHashTable = @{
                        type = 'document-sections'
                        attributes = @{
                            'resource-type' = 'Document::Text'
                            content         = "<img src=`"$($UpdatedITGlueDocumentImage.attributes.'inline-resource-url')`">"
                        }
                    }

                    Write-Host "Updating example document section  [ $ExampleDocumentSectionName ]" -ForegroundColor Green
                    $ITGlueUpdatedDocumentSection = (Set-ITGlueDocumentSection -DocumentId $ExistingDocument.id -Id $ExistingDocumentSection.id -Data $UpdatedDocumentSectionHashTable).data

                }
                'Document::Gallery' {

                    #Update Document Image
                    $UpdatedDocumentImageHashTable = @{
                        "type" = "document-images"
                            "attributes"= @{
                                "target" = @{
                                    "type"  = 'gallery'
                                    "id"    = $ExistingDocumentSection.attributes.'document-gallery-id'
                                }
                                "image" = @{
                                    "content"   = $ITGlueBase64LogoInvert
                                    "file-name" = "ITGlueLogo-$ExampleNumber-Updated.png"
                                }
                            }
                    }

                    Write-Host "Updating example [ Type | $ImageType ] image" -ForegroundColor Green
                    $UpdatedITGlueDocumentImage = (New-ITGlueDocumentImage -Data $UpdatedDocumentImageHashTable).data

                }
            }

        }
        else {

            #Create Document
            $NewDocumentHashTable = @{
                type = 'documents'
                attributes = @{
                    name        = $ExampleDocumentName
                }
            }

            Write-Host "Creating example document          [ $ExampleDocumentName ]" -ForegroundColor Green
            $ITGlueNewDocument = (New-ITGlueDocument -OrganizationID $OrganizationID -Data $NewDocumentHashTable).data

            switch ($ImageType) {
                'document'    {

                    #Create Document Image
                    $NewDocumentImageHashTable = @{
                        "type" = "document-images"
                            "attributes"= @{
                                "target" = @{
                                    "type"  = $ImageType
                                    "id"    = $ITGlueNewDocument.id
                                }
                                "image" = @{
                                    "content"   = $ITGlueBase64Logo
                                    "file-name" = "ITGlueLogo-$ExampleNumber.png"
                                }
                            }
                    }

                    Write-Host "Creating example [ Type | $ImageType ] image" -ForegroundColor Green
                    $ITGlueDocumentImage = (New-ITGlueDocumentImage -Data $NewDocumentImageHashTable).data

                    #Create Document Section
                    $NewDocumentSectionHashTable = @{
                        type = 'document-sections'
                        attributes = @{
                            'resource-type' = $Section
                            content         = "<img src=`"$($ITGlueDocumentImage.attributes.'inline-resource-url')`">"
                        }
                    }

                    Write-Host "Creating example document section  [ $ExampleDocumentSectionName ]" -ForegroundColor Green
                    $ITGlueNewDocumentSection = (New-ITGlueDocumentSection -DocumentId $ITGlueNewDocument.id -Data $NewDocumentSectionHashTable).data

                }
                'gallery'     {

                    #Create Document Section
                    $NewDocumentSectionHashTable = @{
                        type = 'document-sections'
                        attributes = @{
                            'resource-type' = $Section
                        }
                    }

                    Write-Host "Creating example document section  [ $ExampleDocumentSectionName ]" -ForegroundColor Green
                    $ITGlueNewDocumentSection = (New-ITGlueDocumentSection -DocumentId $ITGlueNewDocument.id -Data $NewDocumentSectionHashTable).data

                    #Create Document Image
                    $NewDocumentImageHashTable = @{
                        "type" = "document-images"
                            "attributes"= @{
                                "target" = @{
                                    "type"  = $ImageType
                                    "id"    = $ITGlueNewDocumentSection.attributes.'resource-id'
                                }
                                "image" = @{
                                    "content"   = $ITGlueBase64Logo
                                    "file-name" = "ITGlueLogo-$ExampleNumber.png"
                                }
                            }
                    }

                    Write-Host "Creating example [ Type | $ImageType ] image" -ForegroundColor Green
                    $ITGlueDocumentImage = (New-ITGlueDocumentImage -Data $NewDocumentImageHashTable).data

                }
            }

        }

        #Clear hashtable's for the next loop
        $NewDocumentHashTable       = $null
        $NewDocumentSectionHashTable= $null
        $NewDocumentImageHashTable  = $null

        $ExampleNumber++

    }
    #End of Loop

#EndRegion  [ Example Code ]

Set-Variable -Name "Test_CurrentDocuments1" -Value $CurrentDocuments -Scope Global -Force

#Region     [ Example Cleanup ]

    if (-not $CurrentDocuments) {
        $CurrentDocuments = [System.Collections.Generic.List[object]]::new()
        $CurrentDocuments = (Get-ITGlueDocument -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    }

    Set-Variable -Name "Test_CurrentDocuments2" -Value $CurrentDocuments -Scope Global -Force

if ($RemoveExamples -and $CurrentDocuments) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($CurrentDocuments | Measure-Object).Count) ] documents from [ $($CurrentDocuments.attributes.'organization-name' | Sort-Object -Unique) ]" }

    #Stage array lists to store example data
    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

    foreach ($Document in $CurrentDocuments) {

        $Sections = (Get-ITGlueDocumentSection -DocumentId $Document.id).data

        #Deletes work for inline images I just didn't want to code it. This works fine for gallery
        foreach ($Image in $Sections.attributes.'document-images') {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting [ $($Image.id) ] image"
            $DeleteImages = Remove-ITGlueDocumentImage -Id $Image.id -Confirm:$false
        }

        $DeleteDocumentHashTable = @{
            type = 'documents'
            attributes = @{ id = $Document.id }
        }
        $ExamplesToDelete.Add($DeleteDocumentHashTable)

    }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($CurrentDocuments | Measure-Object).Count) ] documents"
    $DeletedData = Remove-ITGlueDocument -Data $ExamplesToDelete -Confirm:$false

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $CurrentDocuments -Scope Global -Force

    $CurrentDocuments

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''