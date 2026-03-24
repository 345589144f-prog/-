[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $tokenInfo = & (Join-Path $PSScriptRoot "Get-AvitoAccessToken.ps1")

    Write-Host "Авторизация через Avito API прошла успешно." -ForegroundColor Green
    Write-Host ""
    Write-Host ("Тип токена: " + $tokenInfo.token_type)
    Write-Host ("Срок жизни: " + $tokenInfo.expires_in + " сек.")
    Write-Host ("Scope: " + $tokenInfo.scope)
    Write-Host ("Токен: " + $tokenInfo.access_token_preview)
} catch {
    Write-Host "Не удалось получить токен Avito API." -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}
