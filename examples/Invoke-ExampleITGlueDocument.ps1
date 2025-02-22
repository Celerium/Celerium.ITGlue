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

    .PARAMETER ID
        Document ID

    .PARAMETER BulkEdit
        Defines if the example data should be modified in bulk

    .EXAMPLE
        .\Invoke-ExampleITGlueDocument.ps1 -ID 12345,6789

        Edits the Name,Archived,Public fields for the defined document

        Changes are made individual so in this case 2 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueDocument.ps1 -ID 12345,6789 -BulkEdit -Verbose

        Edits the Name,Archived,Public fields for the defined document

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

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int64[]]$ID,

        [Parameter()]
        [switch]$BulkEdit

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/2) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

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

Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Updating documents"
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
    foreach ($DocumentID in $ID) {

        $ExampleDocumentName = "$ExampleName-$ExampleNumber"

        $Archived   = ($true,$false | Get-Random -Count 1)
        $Public     = ($true,$false | Get-Random -Count 1)
        $Name       = "$ExampleDocumentName-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"

        if ($Archived) { Write-Host "Document [ $DocumentID ] - will be archived" -ForegroundColor DarkBlue }
        if ($Public) {   Write-Host "Document [ $DocumentID ] - will be made public" -ForegroundColor DarkRed }

        #Simple field updates
        $UpdatedDocumentHashTable = @{
            type        = 'documents'
            attributes = @{
                id          = $DocumentID
                name        = $Name
                archived    = $Archived
                public      = $Public
            }
        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatedDocumentHashTable) {
                    $ExampleUpdatedData.Add($UpdatedDocumentHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatedDocumentHashTable) {

                    Write-Host "Updating example document [ $DocumentID ] to [ $Name ]" -ForegroundColor Yellow
                    $ITGlueDocumentReturn = Set-ITGlueDocument -ID $DocumentID -Data $UpdatedDocumentHashTable

                }

                #Add return to object list
                if ($ITGlueDocumentReturn) {
                    $ExampleReturnData.Add($ITGlueDocumentReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatedDocumentHashTable = $null

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

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''