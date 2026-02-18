function Get-ITGlueChecklist {
<#
    .SYNOPSIS
        List or show all checklists in your account

    .DESCRIPTION
        The Get-ITGlueChecklist cmdlet returns a list and or
        shows all checklists in your account or a specific organization

    .PARAMETER OrganizationID
        A valid organization Id in your account

    .PARAMETER ID
        A valid checklist id

    .PARAMETER FilterID
        Filter by checklists id

    .PARAMETER FilterOrganizationID
        Filter organization by id

    .PARAMETER Sort
        Sort results by a defined value

        Allowed values:
        'completed', 'created_at', 'updated_at',
        '-completed', '-created_at', '-updated_at'

    .PARAMETER PageNumber
        Return results starting from the defined number

    .PARAMETER PageSize
        Number of results to return per page

        The maximum number of page results that can be
        requested is 1000

    .PARAMETER Include
        Include additional items from a checklist

        Allowed values: Index endpoint
        attachments, checklist_tasks, user_resource_accesses, group_resource_accesses

        Allowed values: Show endpoint
        attachments, checklist_tasks, user_resource_accesses, group_resource_accesses,
        recent_versions, related_items, authorized_users

    .PARAMETER AllResults
        Returns all items from an endpoint

        This can be used in unison with -PageSize to limit the number of
        sequential requests to the API

    .EXAMPLE
        Get-ITGlueChecklist

        Returns the first 50 checklists results from your ITGlue account

    .EXAMPLE
        Get-ITGlueChecklist -ID 8765309

        Returns the checklists with the defined id

    .EXAMPLE
        Get-ITGlueChecklist -PageNumber 2 -PageSize 10

        Returns the first 10 results from the second page for checklists
        in your ITGlue account

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Checklists/Get-ITGlueChecklist.html

    .LINK
        https://api.itglue.com/developer/#checklists
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Show', ValueFromPipeline = $true , Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterID,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$FilterOrganizationID,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateSet(   'completed', 'created_at', 'updated_at',
                        '-completed', '-created_at', '-updated_at')]
        [string]$Sort,

        [Parameter(ParameterSetName = 'Index')]
        [int64]$PageNumber,

        [Parameter(ParameterSetName = 'Index')]
        [ValidateRange(1,1000)]
        [int]$PageSize,

        [Parameter(ParameterSetName = 'Index')]
        [Parameter(ParameterSetName = 'Show')]
        [ValidateSet(   'attachments', 'checklist_tasks', 'user_resource_accesses',
                        'group_resource_accesses', 'recent_versions', 'related_items', 'authorized_users')]
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
            'Index' {

                switch ([bool]$OrganizationID){
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/checklists" }
                    $false  { $ResourceUri = "/checklists" }
                }

            }
            'Show' {

                switch ([bool]$OrganizationID){
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/checklists/$ID" }
                    $false  { $ResourceUri = "/checklists/$ID" }
                }

            }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($FilterID)              { $UriParameters['filter[id]']   = $FilterID }
            if ($FilterOrganizationID)  { $UriParameters['filter[organization_id]']   = $FilterOrganizationID }
            if ($Sort)                  { $UriParameters['sort']         = $Sort }
            if ($PageNumber)            { $UriParameters['page[number]'] = $PageNumber }
            if ($PageSize)              { $UriParameters['page[size]']   = $PageSize }
        }

        if($Include) { $UriParameters['include'] = $Include }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-ITGlueRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
