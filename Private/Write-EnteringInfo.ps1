function Write-EnteringInfo {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'MyInvocation object')]
        [object]
        $Invocation,

        [Parameter()]
        [object]
        $BoundParameters
    )

    'Entered {0} function.' -f $Invocation.InvocationName | Write-Verbose

    if ($PSBoundParameters.ContainsKey('BoundParameters')) {

        $BoundParameters.Keys |
        Where-Object { 'Debug', 'Verbose', 'WhatIf', 'Confirm' -notcontains $_ } |
        ForEach-Object {

            'Param {0}: {1}' -f $_, $BoundParameters.$_ | Write-Verbose
        }
    }
}
