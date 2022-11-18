<#
.SYNOPSIS
    Call SAPControl's RestartService WebMethod.

.DESCRIPTION
    Use this function to restart a sapstartsrv Web service.

.EXAMPLE
    $sap | Restart-PSSAPControl
    Restart sapstartsrv, using existing SAPControl web service connection.

.NOTES
    OverloadDefinitions
    -------------------
    void RestartService()
#>
function Restart-PSSAPControl {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters

    $ErrorActionPreference = 'Stop'

    try {

        $Result = $SapControlConnection.RestartService()

        $returnValue = $Result
    }
    catch {

        Write-Error $_

        $returnValue = $null
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
