function Get-ITGlueDocumentSection {
<#
    .SYNOPSIS
        Returns a list of sections for the specified document

    .DESCRIPTION
        The Get-ITGlueDocumentSection cmdlet returns a list of sections
        for the specified document, ordered by sort

        Sections are polymorphic and contain different attributes based on resource_type

    .PARAMETER DocumentId
        A document ID

    .PARAMETER FilterId
        Filter section ID

    .PARAMETER FilterResourceType
        Filter document ID

        Document::Text - Rich text content
        Document::Heading - Heading with level (1-6)
        Document::Gallery - Image gallery container
        Document::Step - Procedural step with optional duration and gallery

    .PARAMETER FilterDocumentId
        Filter document ID

    .PARAMETER Sort
        Sort sections

        Allowed values:
        'sort', 'id', 'created_at', 'updated_at'
        '-sort', '-id', '-created_at', '-updated_at'

    .PARAMETER ID
        Get a document by id

    .EXAMPLE
        Get-ITGlueDocumentSection -DocumentId 8765309

        Returns all the document sections for the document with the defined id

    .EXAMPLE
        Get-ITGlueDocumentSection -DocumentId 123456 -ID 8765309

        Returns the defined document sections for the document with the defined id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/DocumentSections/Get-ITGlueDocumentSection.html

    .LINK
        https://api.itglue.com/developer/#documentsections
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index', ValueFromPipeline = $true, Mandatory = $true)]
        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true, Mandatory = $true)]
        [int64]$DocumentId,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterId,

        [Parameter(ParameterSetName = 'Index')]
        [string]$FilterResourceType,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterDocumentID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'sort', 'id', 'created_at', 'updated_at',
                        '-sort', '-id', '-created_at', '-updated_at'
        )]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$Id
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $ResourceUri = "/documents/$DocumentId/relationships/sections" }
            'Show'  { $ResourceUri = "/documents/$DocumentId/relationships/sections/$Id" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterId)              { $UriParameters['filter[id]']              = $FilterId }
            if ($FilterResourceType)    { $UriParameters['filter[resource_type]']   = $FilterResourceType }
            if ($FilterDocumentId)      { $UriParameters['filter[document_id]']     = $FilterDocumentId }
            if ($Sort)                  { $UriParameters['sort']                    = $Sort }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters

    }

    end {}

}
