param(
    [string]$EnvPath = (Join-Path $PSScriptRoot "..\.env"),
    [switch]$Raw
)

$envValues = & (Join-Path $PSScriptRoot "Load-Env.ps1") -EnvPath $EnvPath

$clientId = $envValues["AVITO_CLIENT_ID"]
$clientSecret = $envValues["AVITO_CLIENT_SECRET"]

if (-not $clientId) {
    throw "В .env не заполнен AVITO_CLIENT_ID"
}

if (-not $clientSecret) {
    throw "В .env не заполнен AVITO_CLIENT_SECRET"
}

$body = @{
    grant_type = "client_credentials"
    client_id = $clientId
    client_secret = $clientSecret
}

$response = Invoke-RestMethod `
    -Method Post `
    -Uri "https://api.avito.ru/token" `
    -Body $body `
    -ContentType "application/x-www-form-urlencoded"

if ($Raw) {
    return $response
}

$maskedToken = if ($response.access_token.Length -gt 10) {
    $response.access_token.Substring(0, 6) + "..." + $response.access_token.Substring($response.access_token.Length - 4)
} else {
    "***"
}

[PSCustomObject]@{
    token_type = $response.token_type
    expires_in = $response.expires_in
    scope = $response.scope
    access_token_preview = $maskedToken
}

