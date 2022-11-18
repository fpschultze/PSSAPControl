<#
.SYNOPSIS
    Call SAPControl's StopSystem WebMethod.

.DESCRIPTION
    Use this function to trigger the stop of a complete SAP system or parts of it.

    Instances are stopped from highest to lowest priority.
    All instances with the same priority level are stopped in parallel.
    Once all instances of a level are fully stopped, the system stop continues with the next level.
    Get-PSSAPInstance provides a list of all instances of the system with its assigned priority level.

.EXAMPLE
    $sap | Stop-PSSAPSystem

.EXAMPLE
    Stop-PSSAPSystem -SapControlConnection $sap

.NOTES
    OverloadDefinitions
    -------------------
    void StopSystemAsync(StartStopOption options, string prioritylevel, int softtimeout, int waittimeout)
#>
function Stop-PSSAPSystem {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        # Defines which instances to stop
        [Parameter()]
        [ValidateSet('SAPControlALLINSTANCES', 'SAPControlSCSINSTANCES', 'SAPControlDIALOGINSTANCES', 'SAPControlABAPINSTANCES', 'SAPControlJ2EEINSTANCES', 'SAPControlPRIORITYLEVEL', 'SAPControlTREXINSTANCES', 'SAPControlENQREPINSTANCES', 'SAPControlHDBINSTANCES', 'SAPControlALLNOHDBINSTANCES')]
        [PSSAPControl.StartStopOption]
        $StartStopOption = 'SAPControlALLINSTANCES',

        # If StartStopOption is SAPControlPRIORITYLEVEL, the PriorityLevel parameter defines down to which instance priority level instances should be stopped.
        [Parameter()]
        [string]
        $PriorityLevel,

        # Specifies a timeout in sec for a soft shutdown. If the timeout expires, a hard shutdown is used for the remaining instances.
        [Parameter()]
        [int]
        $SoftTimeoutSec = 0,

        # Specifies a timeout in sec to wait for an instance to stop. If the timeout expires, the operation will continue stopping the remaining instances.
        [Parameter()]
        [int]
        $WaitTimeoutSec = 7200
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'StopSystemCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapControlConnection | Initialize-SapControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

        $SapControlConnection.StopSystemAsync($StartStopOption, $PriorityLevel, $SoftTimeoutSec, $WaitTimeoutSec)


        # Wait for response

        $Result = Wait-SapControlEvent -SourceIdentifier $SourceIdentifier


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
