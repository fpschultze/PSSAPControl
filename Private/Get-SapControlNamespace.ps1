function Get-SapControlNamespace {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection
    )
    Write-Output $SapControlConnection.GetType().Namespace
}
