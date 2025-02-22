<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueContact script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new contacts
        in a defined organization. All subsequent runs will then update
        various fields of those contacts

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
        .\Invoke-ExampleITGlueContact.ps1 -OrganizationID 12345

        Checks for existing contacts and either updates or creates new example contacts

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueContact.ps1 -OrganizationID 12345 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing contacts and either updates or creates new example contacts in bulk, then
        it will prompt to delete all the contacts

        API calls are made in bulk so as an example if 5 contacts are created then
        only 1 API call is made to create the 5 new contacts

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new contacts & 1x to delete 5 contacts

        Progress information is sent to the console while the script is running


    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#contacts

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
    $ExampleName    = 'ExampleContact'

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
    $CurrentContacts = (Get-ITGlueContact -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentContacts) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentContacts| Measure-Object).Count) ] existing contacts"
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
        $ExampleNewData     = [System.Collections.Generic.List[object]]::new()
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleContactName = "$ExampleName-$ExampleNumber"

        $ExistingContact = $CurrentContacts | Where-Object {$_.attributes.name -eq $ExampleContactName}

        if ($ExistingContact) {

            #Simple Contact field updates
            $UpdatedContactHashTable = @{
                type        = 'contacts'
                attributes = @{
                    id          = $ExistingContact.id
                    title       = "Title-Updated-$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                    important   = $($true,$false | Get-Random -Count 1)
                    notes       = "$(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss') - Updated example notes"
                }
            }

        }
        else {

            #Example Hashtable with new Contact information
            $NewContactHashTable = @{
                type        = 'contacts'
                attributes = @{
                    'first_name'= $ExampleContactName
                    title       = "ExampleTitle"
                    important   = $($true,$false | Get-Random -Count 1)
                    notes       = "Example notes"
                }
            }
        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdatedContactHashTable) {
                    $ExampleUpdatedData.Add($UpdatedContactHashTable)
                }

                if ($NewContactHashTable) {
                    $ExampleNewData.Add($NewContactHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdatedContactHashTable) {

                    Write-Host "Updating example Contact [ $ExampleContactName ]" -ForegroundColor Yellow
                    $ITGlueContactReturn = Set-ITGlueContact -OrganizationID $OrganizationID -ID $ExistingContact.id -Data $UpdatedContactHashTable

                }

                if ($NewContactHashTable) {

                    Write-Host "Creating example Contact          [ $ExampleContactName ]" -ForegroundColor Green
                    $ITGlueContactReturn = New-ITGlueContact -OrganizationID $OrganizationID -Data $NewContactHashTable

                }

                #Add return to object list
                if ($ITGlueContactReturn) {
                    $ExampleReturnData.Add($ITGlueContactReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdatedContactHashTable    = $null
        $NewContactHashTable        = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] contacts"
            $ExampleReturnData = Set-ITGlueContact -Data $ExampleUpdatedData
        }

        if ($ExampleNewData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewData | Measure-Object).Count) ] contacts"
            $ExampleReturnData = New-ITGlueContact -OrganizationID $OrganizationID -Data $ExampleNewData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] contacts from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    switch ($BulkEdit) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] contacts"

            #Stage array lists to store example data
            $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

            foreach ($Contact in $ExampleReturnData.data) {

                $DeleteContactHashTable = @{
                    type = 'contacts'
                    attributes = @{ id = $Contact.id }
                }

                $ExamplesToDelete.Add($DeleteContactHashTable)

            }

            $DeletedData = Remove-ITGlueContact -Data $ExamplesToDelete -Confirm:$false

        }
        $false  {

            foreach ($Contact in $ExampleReturnData) {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting Contact [ $($Contact.data.attributes.name) ] from [  $($Contact.data.attributes.'organization-name') ]"
                $DeletedData = Remove-ITGlueContact -FilterID $Contact.data.id -Confirm:$false
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