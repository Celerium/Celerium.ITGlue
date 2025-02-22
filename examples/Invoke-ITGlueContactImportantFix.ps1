<#
    .SYNOPSIS
        Sets contacts null important field

    .DESCRIPTION
        The Invoke-ITGlueContactImportantFix script
        bulk sets all contacts with a null important field
        to a true or false value.

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to ITGlue

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER ImportantValue
        Define what value to set

        Allowed Values
        'true', 'false'

    .EXAMPLE
        .\Invoke-ITGlueContactImportantFix.ps1

        Finds all contacts in ITGlue with a null important field and
        set the field to false

        No progress information is sent to the console while the script is running

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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter()]
        [string]$APIKey,

        [Parameter()]
        [string]$APIUri,

        [Parameter(Mandatory = $true)]
        [ValidateSet('true','false')]
        [string]$ImportantValue

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1

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

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Searching for contacts"
    $StepNumber++

#Region     [ Find Contacts ]

    $CurrentContacts = (Get-ITGlueContact -AllResults -PageSize 1000).data | Where-Object {$null -eq $_.attributes.important}

    if ($CurrentContacts) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Found [ $(($CurrentContacts| Measure-Object).Count) ] contact with a null important field"
    }
    else{
        Write-Host "No contacts with a null important field found" -ForegroundColor Green
        exit 1
    }

#EndRegion  [ Find Contacts ]

Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Populate examples"
$StepNumber++

#Region     [ Fix Contacts ]

    $ContactsWithoutImportant = [System.Collections.Generic.List[object]]::new()

    foreach ($Contact in $CurrentContacts) {

        $UpdatedContactHashTable = @{
            type        = 'contacts'
            attributes = @{
                id          = $Contact.id
                important   = $ImportantValue
            }
        }

        $ContactsWithoutImportant.Add($UpdatedContactHashTable) > $null

    }


    Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Bulk updating [ $( ($ContactsWithoutImportant | Measure-Object).Count) ] contacts"

    if ($PSCmdlet.ShouldProcess("[ $( ($ContactsWithoutImportant | Measure-Object).Count) ] Contacts with a null important field")) {
        $UpdatedContacts = Set-ITGlueContact -Data $ContactsWithoutImportant
    }

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_ContactsNull" -Value $CurrentContacts -Scope Global -Force -Confirm:$false
    Set-Variable -Name "$($FunctionName)_ContactsFixed" -Value $UpdatedContacts -Scope Global -Force -Confirm:$false

    $UpdatedContacts

#EndRegion  [ Fix Contacts ]

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''