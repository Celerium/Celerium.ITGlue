function Get-ITGlueDocumentFolder {
<#
    .SYNOPSIS
        Returns a list of document folders

    .DESCRIPTION
        The Get-ITGlueDocumentFolder cmdlet returns a list of
        document folders

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterId
        Filter document folder id

    .PARAMETER FilterParentId
        Filter document folder parent id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'name', 'created_at', 'updated_at'
        '-name', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a document folder by id

    .PARAMETER Include
        Include additional values

        Allowed values:
        'user_resource_accesses', 'group_resource_accesses', 'authorized_users', 'ancestors'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueDocumentFolder -OrganizationID 8675309

        Returns the first 50 document folder results from your ITGlue account

    .EXAMPLE
        Get-ITGlueDocumentFolder -OrganizationID 8675309 -ID 8765309

        Returns the document folder with the defined id

    .EXAMPLE
        Get-ITGlueDocumentFolder -OrganizationID 8675309 -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for document folders
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentFolders/Get-ITGlueDocumentFolder.html

    .LINK
        https://api.itglue.com/developer/#document-folders
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', ValueFromPipeline = $true , Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterId,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterParentId,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'name', 'created_at', 'updated_at',
                        '-name', '-created_at', '-updated_at'
        )]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('user_resource_accesses', 'group_resource_accesses', 'authorized_users', 'ancestors')]
        [string]$Include,

        [Parameter(ParameterSetName = 'Index')]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/organizations/$OrganizationID/relationships/document_folders" }
            'Show'  { $ResourceUri = "/organizations/$OrganizationID/relationships/document_folders/$ID" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterId)          { $UriParameters['filter[id]']        = $FilterId }
            if ($PSBoundParameters.ContainsKey('FilterParentId')) { $UriParameters['filter[parent_id]'] = $FilterParentId }
            if ($Sort)              { $UriParameters['sort']              = $Sort }
            if ($PageNumber)        { $UriParameters['page[number]']      = $PageNumber }
            if ($PageSize)          { $UriParameters['page[size]']        = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {
            if ($Include) { $UriParameters['include'] = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
