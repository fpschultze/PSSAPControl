function Test-SapControlSourceIdentifier {

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $SourceIdentifier
    )

    if ($null -ne (Get-Variable -Name PSSAPControlEvent -Scope Script -ErrorAction Ignore)) {

        $SourceIdentifier -in $Script:PSSAPControlEvent
    }
}
