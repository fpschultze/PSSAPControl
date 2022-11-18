<#
.SYNOPSIS
    Query SAP instance status.

.DESCRIPTION
    Queries the status of an SAP instance and returns $true when the status is 'GREEN'.

.EXAMPLE
    $sap | Test-PSSAPInstance
    Query the SAP instance status, using existing SAPControl web service connection.
#>
function Test-PSSAPInstance {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        [Parameter()]
        [int]
        $Timeout = 0
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $ErrorActionPreference = 'Stop'

    try {

        #region Get instance number from Url

        if ($SapControlConnection.Url -match '.*:5(?<instanceNr>\d{2})13/.*') {

            [int]$instanceNr = $Matches.instanceNr
        }
        else {

            throw 'Invalid SAPControl connection URL'
        }

        #endregion


        #region Get instance status

        $Result = $SapControlConnection |
            Get-PSSAPInstance |
            Where-Object {$_.instanceNr -eq $instanceNr} |
            Select-Object -ExpandProperty dispstatus

        #endregion


        $returnValue = $Result -eq $PSSAPControlSTATECOLOR::SAPControlGREEN
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
