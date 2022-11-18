<#
.SYNOPSIS
    Call SAPControl's Start WebMethod.

.DESCRIPTION
    Use this function to start a SAP instance. Start triggers an instance start.
    The function works asynchronously, which means it triggers the operation and returns immediately.

.EXAMPLE
    $sap | Start-PSSAPInstance

.EXAMPLE
    Start-PSSAPInstance -SapControlConnection $sap

.NOTES
    OverloadDefinitions
    -------------------
    Current : void StartAsync(PSSAPControl.Start ParamType)
    Legacy  : void Start(string runlevel)
#>
function Start-PSSAPInstance {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        [Parameter()]
        [AllowNull()]
        [string]
        $RunLevel = $null
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'StartCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapControlConnection | Initialize-SapControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $SapControlConnection.StartAsync($RunLevel)
            }


            # Call Current Api

            default {

                $TypeName = '{0}.Start' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName
            
                $SapControlConnection.StartAsync($ParamType)
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
