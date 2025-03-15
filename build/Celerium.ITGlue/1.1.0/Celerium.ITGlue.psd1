#
# Module manifest for module 'Celerium.ITGlue'
#
# Generated by: David Schulte
#
# Generated on: 2025-02-22
#

@{

    # Script module or binary module file associated with this manifest
    RootModule = 'Celerium.ITGlue.psm1'

    # Version number of this module.
    # Follows https://semver.org Semantic Versioning 2.0.0
    # Given a version number MAJOR.MINOR.PATCH, increment the:
    # -- MAJOR version when you make incompatible API changes,
    # -- MINOR version when you add functionality in a backwards-compatible manner, and
    # -- PATCH version when you make backwards-compatible bug fixes.

    ModuleVersion = '1.1.0'

    # ID used to uniquely identify this module
    GUID = 'ce707f0f-1969-4192-a08b-80f62be28f2f'

    # Author of this module
    Author = 'David Schulte'

    # Company or vendor of this module
    CompanyName = 'Celerium'

    # Description of the functionality provided by this module
    Description = 'This module provides a PowerShell wrapper for the ITGlue API. The IT Glue API is a powerful tool for automation and getting data from external sources into your IT Glue account. It provides a direct, machine-friendly way of accessing your data, so that you can pull it into your own applications or integrate with third-party tools that we dont currently integrate with.'

    # Copyright information of this module
    Copyright = 'https://github.com/Celerium/Celerium.ITGlue/blob/master/LICENSE'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('ConvertTo-ITGlueQueryString','Invoke-ITGlueRequest','Add-ITGlueAPIKey','Get-ITGlueAPIKey','Remove-ITGlueAPIKey','Test-ITGlueAPIKey','Add-ITGlueBaseURI','Get-ITGlueBaseURI','Remove-ITGlueBaseURI','Export-ITGlueModuleSettings','Get-ITGlueModuleSettings','Import-ITGlueModuleSettings','Initialize-ITGlueModuleSettings','Remove-ITGlueModuleSettings','New-ITGlueAttachment','Remove-ITGlueAttachment','Set-ITGlueAttachment','Get-ITGlueConfigurationInterface','New-ITGlueConfigurationInterface','Set-ITGlueConfigurationInterface','Get-ITGlueConfiguration','New-ITGlueConfiguration','Remove-ITGlueConfiguration','Set-ITGlueConfiguration','Get-ITGlueConfigurationStatus','New-ITGlueConfigurationStatus','Set-ITGlueConfigurationStatus','Get-ITGlueConfigurationType','New-ITGlueConfigurationType','Set-ITGlueConfigurationType','Get-ITGlueContact','New-ITGlueContact','Remove-ITGlueContact','Set-ITGlueContact','Get-ITGlueContactType','New-ITGlueContactType','Set-ITGlueContactType','Get-ITGlueCopilotSmartAssistDocument','Remove-ITGlueCopilotSmartAssistDocument','Set-ITGlueCopilotSmartAssistDocument','Get-ITGlueCountry','Set-ITGlueDocument','Get-ITGlueDomain','Get-ITGlueExpiration','Get-ITGlueExport','New-ITGlueExport','Remove-ITGlueExport','Get-ITGlueFlexibleAssetField','New-ITGlueFlexibleAssetField','Remove-ITGlueFlexibleAssetField','Set-ITGlueFlexibleAssetField','Get-ITGlueFlexibleAsset','New-ITGlueFlexibleAsset','Remove-ITGlueFlexibleAsset','Set-ITGlueFlexibleAsset','Get-ITGlueFlexibleAssetType','New-ITGlueFlexibleAssetType','Set-ITGlueFlexibleAssetType','Get-ITGlueGroup','Get-ITGlueLocation','New-ITGlueLocation','Remove-ITGlueLocation','Set-ITGlueLocation','Get-ITGlueLog','Get-ITGlueManufacturer','New-ITGlueManufacturer','Set-ITGlueManufacturer','Get-ITGlueModel','New-ITGlueModel','Set-ITGlueModel','Get-ITGlueOperatingSystem','Get-ITGlueOrganization','New-ITGlueOrganization','Remove-ITGlueOrganization','Set-ITGlueOrganization','Get-ITGlueOrganizationStatus','New-ITGlueOrganizationStatus','Set-ITGlueOrganizationStatus','Get-ITGlueOrganizationType','New-ITGlueOrganizationType','Set-ITGlueOrganizationType','Get-ITGluePasswordCategory','New-ITGluePasswordCategory','Set-ITGluePasswordCategory','Get-ITGluePassword','New-ITGluePassword','Remove-ITGluePassword','Set-ITGluePassword','Get-ITGluePlatform','Get-ITGlueRegion','New-ITGlueRelatedItem','Remove-ITGlueRelatedItem','Set-ITGlueRelatedItem','Get-ITGlueUserMetric','Get-ITGlueUser','Set-ITGlueUser')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = @('Set-ITGlueAPIKey','Set-ITGlueBaseURI')

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess.
    PrivateData = @{
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('ITGlue', 'Kaseya', 'API', 'PowerShell', 'Windows', 'MacOS', 'Linux', 'PSEdition_Desktop', 'PSEdition_Core', 'Celerium')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Celerium/Celerium.ITGlue/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Celerium/Celerium.ITGlue'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/Celerium/Celerium.ITGlue/refs/heads/main/.github/images/PoSHGallery_Celerium.ITGlue.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/Celerium/Celerium.ITGlue/blob/master/README.md'

            # Identifies the module as a prerelease version in online galleries.
            #PreRelease = '-BETA'

            # Indicate whether the module requires explicit user acceptance for install, update, or save.
            RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

