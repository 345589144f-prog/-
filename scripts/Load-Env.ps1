param(
    [string]$EnvPath = (Join-Path $PSScriptRoot "..\.env")
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Test-Path $EnvPath)) {
    throw "Файл .env не найден: $EnvPath"
}

$values = @{}

Get-Content -Path $EnvPath | ForEach-Object {
    $line = $_.Trim()

    if (-not $line -or $line.StartsWith("#")) {
        return
    }

    $pair = $line -split "=", 2
    if ($pair.Count -ne 2) {
        return
    }

    $key = $pair[0].Trim()
    $value = $pair[1].Trim()

    if ($key) {
        $values[$key] = $value
    }
}

return $values
