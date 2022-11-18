Join-Path -Path $PSScriptRoot -ChildPath 'Private' |
    Get-ChildItem -Filter '*.ps1' -Exclude '*.Tests.*' -Recurse |
    ForEach-Object {
        . $_.FullName
    }

Join-Path -Path $PSScriptRoot -ChildPath 'Public' |
    Get-ChildItem -Filter '*.ps1' -Exclude '*.Tests.*' -Recurse |
    ForEach-Object {
        . $_.FullName
        Export-ModuleMember -Function $_.BaseName
    }

$VerbosePreference = 'Continue'
