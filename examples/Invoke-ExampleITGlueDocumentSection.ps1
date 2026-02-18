<#
    .SYNOPSIS
        Edits document information

    .DESCRIPTION
        The Invoke-ExampleITGlueDocument script edits
        a defined document

        By default this script will update the following
        document fields

        Name,Archived,Public

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
        .\Invoke-ExampleITGlueDocument.ps1 OrganizationID 12345 -Verbose

        Creates 5 example documents with various sections inside each

        Changes are not made in bulk because sections do not support bulk options

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#documents

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
    $ExampleName    = 'ExampleDocumentSection'

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

    $CurrentDocuments = (Get-ITGlueDocument -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentDocuments) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentDocuments| Measure-Object).Count) ] existing documents"
        $ITGlueExampleDocuments = $CurrentDocuments
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate Examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ([bool]$ITGlueExampleDocuments -eq $false) {
        $ITGlueExampleDocuments = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $Section = 'Document::Text','Document::Step' | Get-Random -Count 1

        $ExampleDocumentName        = "$ExampleName-$ExampleNumber"
        $ExampleDocumentSectionName = "$ExampleName-$Section-$ExampleNumber"

        $ExistingDocument = $CurrentDocuments | Where-Object {$_.attributes.name -like "$ExampleDocumentName*"}

        if ($ExistingDocument) {

            $DocumentSections = (Get-ITGlueDocumentSection -DocumentId $ExistingDocument.id).data

            #Simple document section updates
            $NewDocumentSectionHashTable = @{
                type = 'document-sections'
                attributes = @{
                    content = "$ExampleDocumentSectionName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HHmmss')"
                }
            }

            Write-Host "Updating example document section          [ $ExampleDocumentSectionName ]" -ForegroundColor Green
            $ITGlueDocumentReturn = Set-ITGlueDocumentSection -DocumentId $ExistingDocument.id -Id $DocumentSections.id -Data $NewDocumentSectionHashTable

        }
        else {

            #Example Hashtable with new document information
            $NewDocumentHashTable = @{
                type = 'documents'
                attributes = @{
                    name        = $ExampleDocumentName
                }
            }

            Write-Host "Creating example document          [ $ExampleDocumentName ]" -ForegroundColor Green
            $ITGlueNewDocument = (New-ITGlueDocument -OrganizationID $OrganizationID -Data $NewDocumentHashTable).data
            $ITGlueExampleDocuments.Add($ITGlueNewDocument)

            $NewDocumentSectionHashTable = @{
                type = 'document-sections'
                attributes = @{
                    'resource-type' = $Section
                    content         = $ExampleDocumentSectionName
                }
            }

            Write-Host "Creating example document section  [ $ExampleDocumentSectionName ]" -ForegroundColor Green
            $ITGlueDocumentReturn = New-ITGlueDocumentSection -DocumentId $ITGlueNewDocument.id -Data $NewDocumentSectionHashTable

        }

        if ($ITGlueDocumentReturn) {
            $ExampleReturnData.Add($ITGlueDocumentReturn)
        }

        #Clear hashtable's for the next loop
        $NewDocumentHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] sections & their documents" }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] sections & their documents"

    #Stage array lists to store example data
    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()
    foreach ($Document in $ITGlueExampleDocuments) {

        $Sections = (Get-ITGlueDocumentSection -DocumentId $Document.id).data

        foreach ($Section in $Sections) {
            $DeletedData = Remove-ITGlueDocumentSection -DocumentId $Document.id -Id $Section.id -Confirm:$false
        }

        $DeleteDocumentHashTable = @{
            type = 'documents'
            attributes = @{ id = $Document.id }
        }
        $ExamplesToDelete.Add($DeleteDocumentHashTable)

    }

    $DeletedData = Remove-ITGlueDocument -Data $ExamplesToDelete -Confirm:$false

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''