<#
.SYNOPSIS
    Set SAPControl web service credential.

.DESCRIPTION
    Sets or changes the Credential property of an existing SAPControl web service connection.
    Returns $true on success.

.EXAMPLE
    $sap | Set-PSSAPControlCredential -Credential (Get-Credential)

.EXAMPLE
    Set-PSSAPControlCredential -SapControlConnection $sap -Credential (Get-Credential)

.OUTPUTS
    bool
#>
function Set-PSSAPControlCredential {

    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        # Required to call a protected WebMethod like ABAPGetWPTable.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [PSCredential]
        $Credential
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters

    $ErrorActionPreference = 'Stop'

    try {

        $SapControlConnection.Credentials = $Credential.GetNetworkCredential()

        $returnValue = $true
    }
    catch {

        Write-Error $_

        $returnValue = $false
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
