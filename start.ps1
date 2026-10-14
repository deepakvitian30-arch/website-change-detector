# ==============================================================================
# VINNOVATE IT CLUB - WEBSITE CHANGE DETECTOR
# Unified Launch Script (Windows PowerShell)
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Starting Website Change Detector Services" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$Root = $PSScriptRoot

# 1. Start Test Site (port 8088)
Write-Host "[1/3] Starting Controlled Test Site on http://127.0.0.1:8088..." -ForegroundColor Yellow
$TestSiteJob = Start-Process -FilePath "$Root\venv\Scripts\python.exe" -ArgumentList "-m uvicorn test_site.server:app --host 127.0.0.1 --port 8088" -WorkingDirectory $Root -PassThru -NoNewWindow

Start-Sleep -Seconds 2

# 2. Start FastAPI Backend + Scheduler + Queue Worker (port 8000)
Write-Host "[2/3] Starting FastAPI Backend + Scheduler on http://127.0.0.1:8000..." -ForegroundColor Yellow
$BackendJob = Start-Process -FilePath "$Root\venv\Scripts\python.exe" -ArgumentList "-m uvicorn app.main:app --app-dir backend --host 127.0.0.1 --port 8000" -WorkingDirectory $Root -PassThru -NoNewWindow

Start-Sleep -Seconds 2

# 3. Start Frontend Dev Server (port 5173)
Write-Host "[3/3] Starting React + Vite Frontend on http://localhost:5173..." -ForegroundColor Yellow
$FrontendJob = Start-Process -FilePath "npm.cmd" -ArgumentList "run dev" -WorkingDirectory "$Root\frontend" -PassThru -NoNewWindow

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " All services started!" -ForegroundColor Green
Write-Host "   - Frontend UI:  http://localhost:5173" -ForegroundColor Green
Write-Host "   - Backend API:  http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "   - Test Site:    http://127.0.0.1:8088" -ForegroundColor Green
Write-Host " Press Ctrl+C in this terminal to stop all services." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Green

try {
    Wait-Process -Id $BackendJob.Id, $FrontendJob.Id, $TestSiteJob.Id
} finally {
    Stop-Process -Id $TestSiteJob.Id -ErrorAction SilentlyContinue
    Stop-Process -Id $BackendJob.Id -ErrorAction SilentlyContinue
    Stop-Process -Id $FrontendJob.Id -ErrorAction SilentlyContinue
}
