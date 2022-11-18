<#
.SYNOPSIS
    Call SAPControl's GetProcessList WebMethod.

.DESCRIPTION
    Returns a list of all processes directly started by the SAPControl web service according to the SAP start profile.

.EXAMPLE
    $sap | Get-PSSAPProcessList
    Get the process list, using existing SAPControl web service connection.

.NOTES
    OverloadDefinitions
    -------------------
    Current : PSSAPControl.GetProcessListResponse GetProcessList(PSSAPControl.GetProcessList GetProcessList1)
    Legacy  : OSProcess[] GetProcessList()
#>
function Get-PSSAPProcessList {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $ErrorActionPreference = 'Stop'

    try {

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $Result = $SapControlConnection.GetProcessList()
            }


            # Call Current Api

            default {

                $TypeName = '{0}.GetProcessList' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName

                $Result = $SapControlConnection.GetProcessList($ParamType) | Select-Object -ExpandProperty process
            }
        }

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
