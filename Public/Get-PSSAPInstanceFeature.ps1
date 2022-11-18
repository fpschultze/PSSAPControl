<#
.SYNOPSIS
    Query the features of an SAP instance.

.DESCRIPTION
    Queries the features of an SAP instance.

.EXAMPLE
    $sap | Get-PSSAPInstanceFeature
    Query the SAP instance features, using existing SAPControl web service connection.
#>
function Get-PSSAPInstanceFeature {

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

        # Get instance number from Url

        if ($SapControlConnection.Url -match '.*:5(?<instanceNr>\d{2})13/.*') {

            [int]$instanceNr = $Matches.instanceNr
        }
        else {

            throw 'Invalid SAPControl connection URL'
        }


        # Get instance status

        $Result = $SapControlConnection |
            Get-PSSAPInstance |
            Where-Object {$_.instanceNr -eq $instanceNr} |
            Select-Object -ExpandProperty features


        $returnValue = $Result.Split('|')
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
