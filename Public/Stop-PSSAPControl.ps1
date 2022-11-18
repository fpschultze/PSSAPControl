<#
.SYNOPSIS
    Call SAPControl's StopService WebMethod.

.DESCRIPTION
    Use this function to stop a SAPControl web service.
    However once the web service is stopped you have to start sapstartsrv before using the web service interface again.

.EXAMPLE
    $sap | Stop-PSSAPControl
    Stop sapstartsrv, using existing SAPControl web service connection.

.EXAMPLE
    Stop-PSSAPControl -ComputerName saphost1 -InstanceNumber 01
    Stop sapstartsrv, using the SAPControl web service of the given SAP host and instance number

.NOTES
    OverloadDefinitions
    -------------------
    void StopService()
#>
function Stop-PSSAPControl {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters

    $ErrorActionPreference = 'Stop'

    try {

        $Result = $SapControlConnection.StopService()

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
