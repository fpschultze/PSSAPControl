<#
.SYNOPSIS
    Call SAPControl's StartSystem WebMethod.

.DESCRIPTION
    Use this function to trigger the start of a complete SAP system or parts of it.

    Instances are started from lowest to highest priority.
    All instances with the same priority level are started in parallel.
    Once all instances of a level are fully started, the system start continues with the next level.
    Get-PSSAPInstance provides a list of all instances of the system with its assigned priority level.

.EXAMPLE
    $sap | Start-PSSAPSystem

.EXAMPLE
    Start-PSSAPSystem -SapControlConnection $sap

.NOTES
    OverloadDefinitions
    -------------------
    void StartSystemAsync(StartStopOption options, string prioritylevel, int waittimeout, string runlevel)
#>
function Start-PSSAPSystem {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        # Defines which instances to start
        [Parameter()]
        [ValidateSet('SAPControlALLINSTANCES', 'SAPControlSCSINSTANCES', 'SAPControlDIALOGINSTANCES', 'SAPControlABAPINSTANCES', 'SAPControlJ2EEINSTANCES', 'SAPControlPRIORITYLEVEL', 'SAPControlTREXINSTANCES', 'SAPControlENQREPINSTANCES', 'SAPControlHDBINSTANCES', 'SAPControlALLNOHDBINSTANCES')]
        [PSSAPControl.StartStopOption]
        $StartStopOption = 'SAPControlALLINSTANCES',

        # If StartStopOption is SAPControlPRIORITYLEVEL, the PriorityLevel parameter defines up to which instance priority level instances should be started.
        [Parameter()]
        [string]
        $PriorityLevel,

        # Specifies a timeout in sec to wait for an instance to start. If the timeout expires, remaining instances with a higher instance priority are not started since they rely on the other instances to be running.
        [Parameter()]
        [int]
        $WaitTimeoutSec = 7200,

        [Parameter()]
        [AllowNull()]
        [string]
        $RunLevel = $null
    )

    $SourceIdentifier = 'StartSystemCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapControlConnection | Initialize-SapControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

        $SapControlConnection.StartSystemAsync($StartStopOption, $PriorityLevel, $WaitTimeoutSec, $RunLevel)


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
