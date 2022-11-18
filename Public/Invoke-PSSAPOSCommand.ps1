<#
.SYNOPSIS
    Call SAPControl's OSExecute WebMethod.

.DESCRIPTION
    Execute a command line, wait, and returns Exitcode, PID, and output lines

.EXAMPLE
    $result = $sap | Invoke-PSSAPOSCommand -Command '/usr/sap/scripts/prestop.sh'

.EXAMPLE
    $result = $sap | Invoke-PSSAPOSCommand -Command 'C:\\usr\\sap\\scripts\\prestop.bat'

.NOTES
    OverloadDefinitions
    -------------------
    Current : OSExecute(<Namespace>.OSExecute OSExecute1)
    Legacy  : OSExecute(string command, int async, int timeout, string protocolfile, [ref] int pid, [ref] string[] lines)
#>
function Invoke-PSSAPOSCommand {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapControlConnection,

        # Command line to execute
        [Parameter(Mandatory = $true)]
        [string]
        $Command,

        # Timeout (specified in sec, default 0=infinite). If the timeout is reached the process will be terminated.
        [Parameter()]
        [int]
        $TimeoutSec = 0,

        # stdout/stderr of the command can be redirected to a protocolfile. Use protocolfile=”” for getting the result in the lines output parameter (synchronous only).
        [Parameter()]
        [string]
        $ProtocolFile = ''
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    # Execute synchronously. Return when the command has finished or the timeout is reached.
    $Async = 0


    $ErrorActionPreference = 'Stop'

    try {

        switch ($PSSAPControlLegacyApi) {

            # Call Legacy Api

            $true {

                $responsePid = New-Object -TypeName int
                $responseLines = New-Object -TypeName System.Collections.ArrayList

                $responseExitcode = $SapControlConnection.OSExecute($Command, $Async, $TimeoutSec, $ProtocolFile, [ref]$responsePid, [ref]$responseLines)

                $Result = [pscustomobject]@{
                    exitcode = $responseExitcode
                    pid = $responsePid
                    lines = $responseLines
                }
            }


            # Call Current Api

            default {

                $TypeName = '{0}.OSExecute' -f $Script:PSSAPControlNamespace
                $ParamType = New-Object -TypeName $TypeName
                $ParamType.async = $Async
                $ParamType.command = $Command
                $ParamType.protocolfile = $ProtocolFile
                $ParamType.timeout = $TimeoutSec

                $Result = $SapControlConnection.OSExecute($ParamType)
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
