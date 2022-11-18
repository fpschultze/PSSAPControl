<#
.SYNOPSIS
    Call SAPControl's GetVersionInfo WebMethod.

.DESCRIPTION
    ...

.EXAMPLE
    $sap | Get-PSSAPVersionInfo

.NOTES
    OverloadDefinitions
    -------------------
    Current : PSSAPControl.GetVersionInfoResponse GetVersionInfo(PSSAPControl.GetVersionInfo GetVersionInfo1)
    Legacy  : InstanceVersionInfo[], mt0anwjt, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null GetVersionInfo()
#>
function Get-PSSAPVersionInfo {

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

                $Result = $SapControlConnection.GetVersionInfo()
            }


            # Call Current Api

            default {

                $TypeName = '{0}.GetVersionInfo' -f $Script:PSSAPControlNamespace
                $GetVersionInfo1 = New-Object -TypeName $TypeName
            
                $Result = $SapControlConnection.GetVersionInfo($GetVersionInfo1) | Select-Object -ExpandProperty version
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
