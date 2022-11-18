function Wait-SapControlEvent {

    [CmdletBinding()]
    Param (
        # Specifies the source identifier that this cmdlet waits for events.
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-SapControlSourceIdentifier -SourceIdentifier $_})]
        [string]
        $SourceIdentifier,

        # Specifies the maximum time, in seconds, that Wait-SapControlEvent waits for the event to occur. The default, -1, waits indefinitely.
        [Parameter()]
        [int]
        $TimeoutSec = -1,

        $RetryIntervalSec = 1
    )

    $ErrorActionPreference = 'Stop'
    $returnValue = $null
    $event = $null

    try {

        $timer = [Diagnostics.Stopwatch]::StartNew()

        while (($timer.Elapsed.TotalSeconds -lt $TimeoutSec) -or ($TimeoutSec -eq -1)) {

            $event = Get-Variable -Name $SourceIdentifier -Scope Global -ValueOnly -ErrorAction Ignore

            if ($null -ne $event) {

                break
            }

            Start-Sleep -Seconds $RetryIntervalSec
        }

        $timer.Stop()

        if ($null -eq $event) {

            throw 'The expected event did not occur within the given amount of seconds'
        }

        $event.SourceEventArgs | Format-List -Property * | Out-String | Write-Verbose

        Remove-Variable -Name $SourceIdentifier -Scope Global

        if ($null -ne $event.SourceEventArgs.Error) {

            throw $event.SourceEventArgs.Error
        }

        if ($event.SourceEventArgs.Cancelled) {

            Write-Warning 'Cancelled'

            $returnValue = $false
        }
        else {

            Write-Verbose ('{0} results:' -f $SourceIdentifier)
            $event.SourceEventArgs.Result | Format-List -Property * | Out-String | Write-Verbose

            $eventresult = $event.SourceEventArgs | Select-Object -ExpandProperty Result -ErrorAction Ignore

            if ($null -ne $eventresult) {

                $returnValue = $eventresult
            }
            else {

                $returnValue = $true
            }
        }
    }
    catch {

        Write-Error $_

        $returnValue = $false
    }
    finally {

        Write-Output $returnValue
    }
}
