function Get-ITGlueDocument {
<#
    .SYNOPSIS
        Returns a list of documents

    .DESCRIPTION
        The Get-ITGlueDocument cmdlet returns a list of documents
        or return complete information of a document including its sections

        Index
        Returns only root level documents when document_folder_id is not specified

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER FilterDocumentFolderId
        Filter document folder id

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER ID
        Get a document by id

    .PARAMETER Include
        Include additional values

        Allowed values:
        'attachments', 'related_items'

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueDocument

        Returns the first 50 document results from your ITGlue account

    .EXAMPLE
        Get-ITGlueDocument -ID 8765309

        Returns the document with the defined id

    .EXAMPLE
        Get-ITGlueDocument -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for documents
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Documents/Get-ITGlueDocument.html

    .LINK
        https://api.itglue.com/developer/#documents
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', ValueFromPipeline = $true , Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterDocumentFolderId,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet('attachments', 'related_items')]
        [int64]$Include,

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
            'Index' { $ResourceUri = "/organizations/$OrganizationID/relationships/documents" }
            'Show'  {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/documents/$ID" }
                    $false  { $ResourceUri = "/documents/$ID" }
                }

            }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterDocumentFolderId)    { $UriParameters['filter[document_folder_id]']  = $FilterDocumentFolderId }
            if ($Sort)                      { $UriParameters['sort']                        = $Sort }
            if ($PageNumber)                { $UriParameters['page[number]']                = $PageNumber }
            if ($PageSize)                  { $UriParameters['page[size]']                  = $PageSize }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Show') {
            if ($Include) { $UriParameters['include']   = $Include }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
