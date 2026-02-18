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

    .PARAMETER ID
        Document ID

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleITGlueDocument.ps1 OrganizationID 12345 -ID 12345,6789

        Edits the Name,Archived,Restricted fields for the defined documents

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
        [ValidateNotNullOrEmpty()]
        [int64[]]$ID,

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
    $ExampleName    = 'ExampleDocument'

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
    if ($ID) {
        foreach($DocumentID in $ID){
            $Data = (Get-ITGlueDocument -OrganizationID $OrganizationID -ID $DocumentID).data
        }
        if ($Data){ $CurrentDocuments.Add($Data) }
        else { Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - No documents IDs found matching [ $DocumentID ]" }

    }
    else{ $CurrentDocuments = (Get-ITGlueDocument -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"} }

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
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleDocumentName = "$ExampleName-$ExampleNumber"

        $ExistingDocument = $CurrentDocuments | Where-Object {$_.attributes.name -like "$ExampleDocumentName*"}

        if ($ExistingDocument) {

            #Simple document field updates
            $UpdateDocumentHashTable = @{
                type        = 'documents'
                attributes = @{
                    id          = $ExistingDocument.id
                    name        = "$ExampleDocumentName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HHmmss')"
                    restricted  = ('true','false' | Get-Random -Count 1)
                    archived    = ('true','false' | Get-Random -Count 1)
                }
            }

        }
        else {

            #Example Hashtable with new document information
            $NewDocumentHashTable = @{
                type = 'documents'
                attributes = @{
                    name        = $ExampleDocumentName
                    restricted  = ('true','false' | Get-Random -Count 1)
                    archived    = ('true','false' | Get-Random -Count 1)
                }
            }

            Write-Host "Creating example document          [ $ExampleDocumentName ]" -ForegroundColor Green
            $ITGlueDocumentReturn = New-ITGlueDocument -OrganizationID $OrganizationID -Data $NewDocumentHashTable

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdateDocumentHashTable) {
                    $ExampleUpdatedData.Add($UpdateDocumentHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdateDocumentHashTable) {
                    Write-Host "Updating example document [ $ExampleDocumentName ]" -ForegroundColor Yellow
                    $ITGlueDocumentReturn = Set-ITGlueDocument -OrganizationID $OrganizationID -ID $ExistingDocument.id -Data $UpdateDocumentHashTable
                }

            }
        }

        if ($ITGlueDocumentReturn) {
            $ExampleReturnData.Add($ITGlueDocumentReturn)
        }

        #Clear hashtable's for the next loop
        $UpdateDocumentHashTable    = $null
        $NewDocumentHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] documents"
            $ExampleReturnData = Set-ITGlueDocument -Data $ExampleUpdatedData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] documents from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] documents"

    #Stage array lists to store example data
    $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

    foreach ($Document in $ExampleReturnData.data) {

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