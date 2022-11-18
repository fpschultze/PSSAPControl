<#
.SYNOPSIS
    Call the SAPControl's Stop WebMethod.

.DESCRIPTION
    Use this function to stop a SAP instance. Stop triggers an instance stop.
    SoftTimeoutSec specifies a timeout in sec for a soft shutdown via SIGQUIT, if the timeout expires a hard shutdown is used.
    The function works asynchronously, which means it triggers the operation and returns immediately.

.EXAMPLE
    $sap | Stop-PSSAPInstance

.EXAMPLE
    Stop-PSSAPInstance -SapControlConnection $sap

.NOTES
    OverloadDefinitions
    -------------------
    Current : void StopAsync(PSSAPControl.Stop ParamType)
    Legacy  : void Stop(int softtimeout, int IsSystemStop)
#>
function Stop-PSSAPInstance {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        #Specifies a timeout in sec for a soft shutdown, if the timeout expires a hard shutdown is used
        [Parameter()]
        [int]
        $SoftTimeoutSec = 0,

        [Parameter()]
        [int]
        $IsSystemStop = 0
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'StopCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapControlConnection | Initialize-SapControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $SapControlConnection.StopAsync($SoftTimeoutSec, $IsSystemStop)
            }


            # Call Current Api

            default {

                $TypeName = '{0}.Stop' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName

                $SapControlConnection.StopAsync($ParamType)
            }
        }


        # Wait for response

        $Result = Wait-SapControlEvent -SourceIdentifier $SourceIdentifier


        $returnValue = $Result

        Write-Output $returnValue
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
