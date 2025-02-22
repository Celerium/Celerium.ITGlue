<#
    .SYNOPSIS
        Pester tests for the Celerium.ITGlue baseURI functions

    .DESCRIPTION
        Pester tests for the Celerium.ITGlue baseURI functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\baseUri\Get-ITGlueBaseURI.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\baseUri\Get-ITGlueBaseURI.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .NOTES
        N/A

    .LINK
        https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.6.1' }

#Region     [ Parameters ]

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$moduleName = 'Celerium.ITGlue',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        switch ($buildTarget) {
            'built'     { $modulePath = Join-Path -Path $rootPath -ChildPath "\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = Join-Path -Path $rootPath -ChildPath "$moduleName" }
        }

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

        $modulePsd1 = Join-Path -Path $modulePath -ChildPath "$moduleName.psd1"

        Import-Module -Name $modulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($moduleError) {
            $moduleError
            exit 1
        }

    }

    AfterAll{

        Remove-ITGlueAPIKey -WarningAction SilentlyContinue

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

    }

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]


Describe "Testing [ $commandName ] functions with [ $pester_TestName ]" -Tag @('baseUri') {

Context "[ $commandName ] testing functions" {

    It "[ $commandName ] should have an alias of [ Set-ITGlueBaseURI ]" {
        Get-Alias -Name Set-ITGlueBaseURI | Should -BeTrue
    }

    It "Without parameters should return the default URI" {
        Add-ITGlueBaseURI
        Get-ITGlueBaseURI | Should -Be 'https://api.itglue.com'
    }

    It "Should accept a value from the pipeline" {
        'https://celerium.org' | Add-ITGlueBaseURI
        Get-ITGlueBaseURI | Should -Be 'https://celerium.org'
    }

    It "With parameter -BaseUri <value> should return what was inputted" {
        Add-ITGlueBaseURI -BaseUri 'https://celerium.org'
        Get-ITGlueBaseURI | Should -Be 'https://celerium.org'
    }

    It "With parameter -DataCenter US should return the default URI" {
        Add-ITGlueBaseURI -DataCenter 'US'
        Get-ITGlueBaseURI | Should -Be 'https://api.itglue.com'
    }

    It "With parameter -DataCenter EU should return the default URI" {
        Add-ITGlueBaseURI -DataCenter 'EU'
        Get-ITGlueBaseURI | Should -Be 'https://api.eu.itglue.com'
    }

    It "With parameter -DataCenter AU should return the default URI" {
        Add-ITGlueBaseURI -DataCenter 'AU'
        Get-ITGlueBaseURI | Should -Be 'https://api.au.itglue.com'
    }

    It "With invalid parameter value -DataCenter Space should return an error" {
        Remove-ITGlueBaseURI
        {Add-ITGlueBaseURI -DataCenter Space} | Should -Throw
    }

    It "The default URI should NOT contain a trailing forward slash" {
        Add-ITGlueBaseURI

        $URI = Get-ITGlueBaseURI
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }

    It "A custom URI should NOT contain a trailing forward slash" {
        Add-ITGlueBaseURI -BaseUri 'https://celerium.org/'

        $URI = Get-ITGlueBaseURI
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }
}

}