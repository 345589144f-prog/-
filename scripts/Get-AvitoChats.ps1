param(
    [string]$EnvPath = (Join-Path $PSScriptRoot "..\.env")
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $envValues = & (Join-Path $PSScriptRoot "Load-Env.ps1") -EnvPath $EnvPath
    $userId = $envValues["AVITO_USER_ID"]

    if (-not $userId) {
        throw "В .env не заполнен AVITO_USER_ID"
    }

    $token = & (Join-Path $PSScriptRoot "Get-AvitoAccessToken.ps1") -EnvPath $EnvPath -Raw
    $headers = @{
        Authorization = "Bearer $($token.access_token)"
    }

    $response = Invoke-RestMethod `
        -Method Get `
        -Uri ("https://api.avito.ru/messenger/v2/accounts/" + $userId + "/chats") `
        -Headers $headers

    Write-Host "Список чатов получен." -ForegroundColor Green
    $response | ConvertTo-Json -Depth 8
} catch {
    Write-Host "Не удалось получить чаты из Avito Messenger API." -ForegroundColor Red
    Write-Host $_.Exception.Message

    $response = $_.Exception.Response
    if ($response -and $response.GetResponseStream) {
        try {
            $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
            $body = $reader.ReadToEnd()
            if ($body) {
                Write-Host ""
                Write-Host "Ответ сервера:"
                Write-Host $body
            }
        } catch {
        }
    }

    exit 1
}
