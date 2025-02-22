<#
    .SYNOPSIS
        Populates example data using the Celerium.ITGlue module

    .DESCRIPTION
        The Invoke-ExampleITGlueConfiguration script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new configurations
        in a defined organization. All subsequent runs will then update
        various fields of those configurations

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
        .\Invoke-ExampleITGlueConfiguration.ps1 -OrganizationID 12345

        Checks for existing configurations and either updates or creates new example configurations

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleITGlueConfiguration.ps1 -OrganizationID 12345 -BulkEdit -RemoveExamples -RemoveExamplesConfirm -Verbose

        Checks for existing configurations and either updates or creates new example configurations in bulk, then
        it will prompt to delete all the configurations

        API calls are made in bulk so as an example if 5 configurations are created then
        only 1 API call is made to create the 5 new configurations

        Since RemoveExamples parameter is called then in this example 2 API calls are made
        1x to create 5 new configurations & 1x to delete 5 configurations

        Progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://api.itglue.com/developer/#configurations

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
    $ExampleName    = 'ExampleConfiguration'

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
    $CurrentConfigurations = (Get-ITGlueConfiguration -OrganizationID $OrganizationID -AllResults).data | Where-Object {$_.attributes.name -like "$ExampleName*"}
    if ($CurrentConfigurations) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentConfigurations| Measure-Object).Count) ] existing configurations"
    }

#EndRegion  [ Find Existing Data ]

Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber      = 1
    $ConfigurationTypes = Get-ITGlueConfigurationType

    #Stage array lists to store example data
    $ExampleReturnData      = [System.Collections.Generic.List[object]]::new()
    if ($BulkEdit) {
        $ExampleNewData     = [System.Collections.Generic.List[object]]::new()
        $ExampleUpdatedData = [System.Collections.Generic.List[object]]::new()
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleConfigurationName = "$ExampleName-$ExampleNumber"

        $ExistingConfiguration = $CurrentConfigurations | Where-Object {$_.attributes.name -eq $ExampleConfigurationName}

        if ($ExistingConfiguration) {

            #Simple configuration field updates
            $UpdateConfigurationHashTable = @{
                type = 'configurations'
                attributes = @{
                        #'organization_id'       = $OrganizationID
                        id                      = $ExistingConfiguration.id
                        notes                   = "Here are some updated example notes - $(Get-Date -Format 'yyyy-MM-dd-HH:mm:ss')"
                }
            }

        }
        else {

            #Example Hashtable with new configuration information
            $NewConfigurationHashTable = @{
                type = 'configurations'
                attributes = @{
                        'organization_id'       = $OrganizationID
                        'configuration-type-id' = $ConfigurationTypes.data.id | Get-Random -Count 1
                        name                    = $ExampleConfigurationName
                        notes                   = "Here are some example notes"
                }
                relationships = @{
                    'configuration_interfaces' = @{
                        data = @(
                            @{
                                type        = 'configuration_interfaces'
                                attributes  = @{
                                    name            = 'Ethernet'
                                    'ip-address'    = '192.168.10.100'
                                    primary         = 'true'
                                    'mac-address'   = '11:22:33:44:55:66'
                                }
                            }
                        )
                    }
                }
            }

        }

        switch ($BulkEdit) {
            $true   {

                #If bulk editing then add hashtable into an array list to be used later outside the loop
                if ($UpdateConfigurationHashTable) {
                    $ExampleUpdatedData.Add($UpdateConfigurationHashTable)
                }

                if ($NewConfigurationHashTable) {
                    $ExampleNewData.Add($NewConfigurationHashTable)
                }

            }
            $false  {

                #Non bulk modifications make multiple API calls
                if ($UpdateConfigurationHashTable) {

                    Write-Host "Updating example configuration [ $ExampleConfigurationName ]" -ForegroundColor Yellow
                    $ITGlueConfigurationReturn = Set-ITGlueConfiguration -OrganizationID $OrganizationID -ID $ExistingConfiguration.id -Data $UpdateConfigurationHashTable

                }

                if ($NewConfigurationHashTable) {

                    if ($ExampleConfigurationIsArchived) {
                        Write-Host "Creating example archived configuration [ $ExampleConfigurationName ]" -ForegroundColor DarkBlue
                    }
                    else{
                        Write-Host "Creating example configuration          [ $ExampleConfigurationName ]" -ForegroundColor Green
                    }

                    $ITGlueConfigurationReturn = New-ITGlueConfiguration -OrganizationID $OrganizationID -Data $NewConfigurationHashTable

                }

                #Add return to object list
                if ($ITGlueConfigurationReturn) {
                    $ExampleReturnData.Add($ITGlueConfigurationReturn)
                }

            }
        }

        #Clear hashtable's for the next loop
        $UpdateConfigurationHashTable    = $null
        $NewConfigurationHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

    #Bulk modifications make a single API call using the array list populated inside the loop
    if ($BulkEdit) {

        if ($ExampleUpdatedData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ExampleUpdatedData | Measure-Object).Count) ] configurations"
            $ExampleReturnData = Set-ITGlueConfiguration -Data $ExampleUpdatedData
        }

        if ($ExampleNewData) {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk creating [ $( ($ExampleNewData | Measure-Object).Count) ] configurations"
            $ExampleReturnData = New-ITGlueConfiguration -OrganizationID $OrganizationID -Data $ExampleNewData
        }

    }

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/4) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($ExampleReturnData.data | Measure-Object).Count) ] configurations from [ $($ExampleReturnData.data.attributes.'organization-name' | Sort-Object -Unique) ]" }

    switch ($BulkEdit) {
        $true   {

            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk deleting [ $( ($ExampleReturnData.data | Measure-Object).Count) ] configurations"

            #Stage array lists to store example data
            $ExamplesToDelete = [System.Collections.Generic.List[object]]::new()

            foreach ($Configuration in $ExampleReturnData.data) {

                $DeleteConfigurationHashTable = @{
                    type = 'configurations'
                    attributes = @{ id = $Configuration.id }
                }

                $ExamplesToDelete.Add($DeleteConfigurationHashTable)

            }

            $DeletedData = Remove-ITGlueConfiguration -Data $ExamplesToDelete -Confirm:$false

        }
        $false  {

            foreach ($Configuration in $ExampleReturnData) {
                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting configuration [ $($Configuration.data.attributes.name) ] from [  $($Configuration.data.attributes.'organization-name') ]"
                $DeletedData = Remove-ITGlueConfiguration -ID $Configuration.data.id -Confirm:$false
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