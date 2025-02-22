function New-ITGlueOrganization {
<#
    .SYNOPSIS
        Create an organization

    .DESCRIPTION
        The New-ITGlueOrganization cmdlet creates an organization

        Examples of JSON objects can be found under ITGlues developer documentation
            https://api.itglue.com/developer

    .PARAMETER Data
        JSON body depending on bulk changes or not

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-ITGlueRequest function

    .EXAMPLE
        New-ITGlueOrganization -Data $JsonObject

        Creates a new organization with the specified JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.ITGlue/site/Organizations/New-ITGlueOrganization.html

    .LINK
        https://api.itglue.com/developer/#organizations-create
#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory = $true)]
        $Data
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = '/organizations/'

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-ITGlueRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
