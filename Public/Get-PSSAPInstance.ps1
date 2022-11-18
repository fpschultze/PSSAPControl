<#
.SYNOPSIS
    Call SAPControl's GetSystemInstanceList WebMethod.

.DESCRIPTION
    Returns a list of all instances on an SAP host.

.EXAMPLE
    $sap | Get-PSSAPInstance
    Get the instance list, using existing SAPControl web service connection.

.NOTES
    OverloadDefinitions
    -------------------
    Current : GetSystemInstanceList(<Namespace>.GetSystemInstanceList GetSystemInstanceList1)
    Legacy  : SAPInstance[] GetSystemInstanceList(int timeout)
#>
function Get-PSSAPInstance {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        [Parameter()]
        [int]
        $Timeout = -1
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $ErrorActionPreference = 'Stop'

    try {

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $Result = $SapControlConnection.GetSystemInstanceList($Timeout)
            }


            # Call Current Api

            default {

                $TypeName = '{0}.GetSystemInstanceList' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName
            
                $Result = $SapControlConnection.GetSystemInstanceList($ParamType) | Select-Object -ExpandProperty instance
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
