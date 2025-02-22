function Set-ITGlueDocument {
<#
    .SYNOPSIS
        Updates one or more documents

    .DESCRIPTION
        The Set-ITGlueDocument cmdlet updates one or more existing documents

        Any attributes you don't specify will remain unchanged

        This function can call the following endpoints:
            Update =    /documents/:id
                        /organizations/:organization_id/relationships/documents/:id

            Bulk_Update =  /documents

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER OrganizationID
        A valid organization Id in your Account

    .PARAMETER ID
        The document id to update

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        Set-ITGlueDocument -id 8675309 -Data $JsonObject

        Updates the defined document with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Documents/Set-ITGlueDocument.html

    .LINK
        https://api.itglue.com/developer/#documents-update
#>

    [CmdletBinding(DefaultParameterSetName = 'Bulk_Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(ParameterSetName = 'Update')]
        [Parameter(ParameterSetName = 'Bulk_Update')]
        [int64]$OrganizationID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [int64]$ID,

        [Parameter(ParameterSetName = 'Update', Mandatory = $true)]
        [Parameter(ParameterSetName = 'Bulk_Update', Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Update'        {

                switch ([bool]$OrganizationID) {
                    $true   { $ResourceUri = "/organizations/$OrganizationID/relationships/documents/$ID" }
                    $false  { $ResourceUri = "/documents/$ID" }
                }

            }
            'Bulk_Update'   { $ResourceUri = "/documents" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method PATCH -ResourceURI $ResourceUri -Data $Data
        }


    }

    end {}

}
