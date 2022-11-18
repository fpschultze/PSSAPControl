<#
.SYNOPSIS
    Call SAPControl's GetSystemInstanceListAsync WebMethod.

.DESCRIPTION
    Returns a list of all instances on an SAP host.

.EXAMPLE
    $sap | Get-PSSAPInstanceAsync
    Get the instance list, using existing SAPControl web service connection.
#>
function Get-PSSAPInstanceAsync {

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


    $SourceIdentifier = 'GetSystemInstanceListCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapControlConnection | Initialize-SapControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $SapControlConnection.GetSystemInstanceListAsync($Timeout)
            }


            # Call Current Api

            default {

                $TypeName = '{0}.GetSystemInstanceList' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName
            
                $SapControlConnection.GetSystemInstanceListAsync($ParamType) #| Select-Object -ExpandProperty instance
            }
        }


        # Wait for response

        $Result = Wait-SapControlEvent -SourceIdentifier $SourceIdentifier


        switch ($PSSAPControlLegacyApi) {

            # Legacy Api Result

            $true {

                $returnValue = $Result
            }


            # Current Api Result

            default {

                $Result | Get-Member -MemberType Property | Where-Object {$_.Name -eq 'instance' } | ForEach-Object {

                    $returnValue = $Result | Select-Object -ExpandProperty instance
                }
                if ($null -eq $returnValue) {

                    $returnValue = $Result
                }
            }
        }
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
