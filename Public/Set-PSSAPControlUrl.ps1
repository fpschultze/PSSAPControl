<#
.SYNOPSIS
    Connect to a different SAPControl web service.

.DESCRIPTION
    Connects to a different SAPControl using the an existing SAPControl web service connection by changing the URL.
    Returns $true on success.

.EXAMPLE
    $sap | Set-PSSAPControlUrl -ComputerName saphost1 -InstanceNumber 11

.EXAMPLE
    Set-PSSAPControlUrl -SapControlConnection $sap -ComputerName saphost1 -InstanceNumber 11

.OUTPUTS
    bool
#>
function Set-PSSAPControlUrl {

    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^([0-8]\d{1}|9[0-7])$')]
        [string]
        $InstanceNumber
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters

    $urlTemplate = 'http://{0}:5{1}13?wsdl'
    $simpleIpRegEx = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

    $ErrorActionPreference = 'Stop'

    try {

        if ($ComputerName -match $simpleIpRegEx) {

            $fqdnOrIp = [ipaddress]$ComputerName  | Select-Object -ExpandProperty IPAddressToString
        }
        else {

            $fqdnOrIp = [System.Net.Dns]::GetHostByName($ComputerName) | Select-Object -ExpandProperty HostName
        }

        $wsdlUrl = $urlTemplate -f $fqdnOrIp, $InstanceNumber


        #region Set URL

        $SapControlConnection.Url = $wsdlUrl

        #endregion


        $returnValue = $true
    }
    catch {

        Write-Error $_

        $returnValue = $false
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
