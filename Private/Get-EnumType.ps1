function Get-EnumType {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Namespace
    )

    [AppDomain]::CurrentDomain.GetAssemblies() |
        Where-Object { ($_.GlobalAssemblyCache -eq $false) -and ($_.IsDynamic -eq $false) } |
        ForEach-Object { $_.GetExportedTypes() } |
        Where-Object { ($_.Namespace -eq $Namespace) -and $_.IsEnum }
}
