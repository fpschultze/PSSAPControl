function Write-LeavingInfo {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'MyInvocation object')]
        [object]
        $Invocation,

        [Parameter()]
        [object]
        $Result,

        [Parameter()]
        [object]
        $BoundParameters
    )

    'Leaving {0} function.' -f $Invocation.InvocationName | Write-Verbose

    if ($PSBoundParameters.ContainsKey('BoundParameters')) {

        $BoundParameters.Keys |
        Where-Object { 'Debug', 'Verbose', 'WhatIf', 'Confirm' -notcontains $_ } |
        ForEach-Object {

            'Param {0}: {1}' -f $_, $BoundParameters.$_ | Write-Verbose
        }
    }

    if ($PSBoundParameters.ContainsKey('Result')) {

        if ($null -eq $Result) {

            'Result: NULL-Value' | Write-Verbose
        }
        else {

            'Result:' | Write-Verbose
            $Result | Format-List -Property * | Out-String | Write-Verbose
<#
            try {

                $Result.ToString() | Write-Verbose -ErrorAction Stop
            }
            catch {

                $Result.GetType().ToString() | Write-Verbose -ErrorAction Ignore
            }
#>
        }
    }
}
