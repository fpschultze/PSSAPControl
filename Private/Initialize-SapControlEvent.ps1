function Initialize-SapControlEvent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        # Specifies the sap control event source identifier.
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-SapControlSourceIdentifier -SourceIdentifier $_})]
        [string]
        $SourceIdentifier
    )

    # Remove old stuff

    Remove-Variable -Name $SourceIdentifier -Scope Global -ErrorAction Ignore

    Get-EventSubscriber -SourceIdentifier $SourceIdentifier -ErrorAction Ignore | Unregister-Event


    # Register web service response as support event

    Register-ObjectEvent -InputObject $SapControlConnection -EventName $SourceIdentifier -SourceIdentifier $SourceIdentifier -Action {

        New-Variable -Name ($Event.MessageData) -Value $Event -Scope Global

    } -MaxTriggerCount 1 -MessageData $SourceIdentifier -SupportEvent
}
