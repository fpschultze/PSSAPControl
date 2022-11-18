<#
.SYNOPSIS
    Call SAPControl's ParameterValue WebMethod.

.DESCRIPTION
    Returns an SAP profile parameter value for a given profile parameter. If the given profile parameter is empty, it returns all known parameter value pairs.

.EXAMPLE
    $sap | Get-PSSAPParameterValue -Name SAPDBHOST
    Get SAPDBHOST's paramater value, using existing SAPControl web service connection

.NOTES
    OverloadDefinitions
    -------------------
    Current : PSSAPControl.ParameterValueResponse ParameterValue(PSSAPControl.ParameterValue ParameterValue1)
    Legacy  : string ParameterValue(string parameter)
#>
function Get-PSSAPParameterValue {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        [Parameter()]
        [string]
        $Name
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $ErrorActionPreference = 'Stop'

    try {

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                if ($PSBoundParameters.ContainsKey('Name')) {

                    $Result = [PSCustomObject]@{
                        Parameter = $Name
                        Value = $SapControlConnection.ParameterValue($Name)
                    }
                }
                else {

                    $Result = $SapControlConnection.ParameterValue($Name)
                }
            }


            # Call Current Api

            default {

                $TypeName = '{0}.ParameterValue' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName
            
                $Result1 = $SapControlConnection.ParameterValue($ParamType) | Select-Object -ExpandProperty value

                if ($PSBoundParameters.ContainsKey('Name')) {

                    $Result1.Split("`n") | Where-Object { $_ -like "${Name}=*" } | ForEach-Object {

                        $Result2 = $_.Split('=')

                        $Result = [PSCustomObject]@{
                            Parameter = $Result2[0]
                            Value = $Result2[1]
                        }
                    }
                }
                else {

                    $Result = $Result1
                }
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
