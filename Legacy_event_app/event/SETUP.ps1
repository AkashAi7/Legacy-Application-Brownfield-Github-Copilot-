# Event App - One-Click Setup Script
# Automatically checks prerequisites, installs if needed, and starts the application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Event Nomination System - Quick Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if command exists
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

# Step 1: Check Java
Write-Host "[1/6] Checking Java..." -ForegroundColor Yellow
if (Test-Command "java") {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "  OK Java found: $javaVersion" -ForegroundColor Green
} else {
    Write-Host "  X Java not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installing Java automatically..." -ForegroundColor Yellow
    
    # Try Chocolatey first
    if (Test-Command "choco") {
        choco install temurin11 -y
    } else {
        Write-Host ""
        Write-Host "Please install Java manually:" -ForegroundColor Red
        Write-Host "1. Visit: https://adoptium.net/temurin/releases/" -ForegroundColor White
        Write-Host "2. Download: Windows x64, JDK 11 LTS" -ForegroundColor White
        Write-Host "3. Install with 'Add to PATH' checked" -ForegroundColor White
        Write-Host "4. Re-run this script" -ForegroundColor White
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Step 2: Check Maven
Write-Host "[2/6] Checking Maven..." -ForegroundColor Yellow
if (Test-Command "mvn") {
    $mavenVersion = mvn -version 2>&1 | Select-Object -First 1
    Write-Host "  OK Maven found: $mavenVersion" -ForegroundColor Green
} else {
    Write-Host "  X Maven not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installing Maven automatically..." -ForegroundColor Yellow
    
    # Try Chocolatey first
    if (Test-Command "choco") {
        choco install maven -y
    } else {
        Write-Host ""
        Write-Host "Please install Maven manually:" -ForegroundColor Red
        Write-Host "1. Visit: https://maven.apache.org/download.cgi" -ForegroundColor White
        Write-Host "2. Extract to: C:\Program Files\Apache\maven" -ForegroundColor White
        Write-Host "3. Add to PATH: C:\Program Files\Apache\maven\bin" -ForegroundColor White
        Write-Host "4. Re-run this script" -ForegroundColor White
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    # Refresh environment
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Step 3: Clean previous builds
Write-Host "[3/6] Cleaning previous builds..." -ForegroundColor Yellow
mvn clean | Out-Null
Write-Host "  OK Clean complete" -ForegroundColor Green

# Step 4: Build project
Write-Host "[4/6] Building project (first run may take 2-5 min)..." -ForegroundColor Yellow
$buildOutput = mvn package -q 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK Build successful" -ForegroundColor Green
} else {
    Write-Host "  X Build failed!" -ForegroundColor Red
    Write-Host $buildOutput
    Read-Host "Press Enter to exit"
    exit 1
}

# Step 5: Start server in background
Write-Host "[5/6] Starting Jetty server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn jetty:run" -WindowStyle Normal
Write-Host "  OK Server starting (new window opened)..." -ForegroundColor Green

# Wait for server to be ready
Write-Host "[6/6] Waiting for server to start..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
$serverReady = $false

while ($attempt -lt $maxAttempts -and -not $serverReady) {
    Start-Sleep -Seconds 2
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/event/" -UseBasicParsing -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            $serverReady = $true
        }
    } catch {
        $attempt++
    }
}

if ($serverReady) {
    Write-Host "  OK Server is running!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Setup Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opening database setup page..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:8080/event/setupDb.jsp"
    
    Start-Sleep -Seconds 3
    Write-Host "Opening login page..." -ForegroundColor Yellow
    Start-Process "http://localhost:8080/event/login.jsp"
    
    Write-Host ""
    Write-Host "Login Credentials:" -ForegroundColor Cyan
    Write-Host "  - admin/admin (Create events)" -ForegroundColor White
    Write-Host "  - emp1/emp1 (Nominate for events)" -ForegroundColor White
    Write-Host "  - approver/approver (Approve nominations)" -ForegroundColor White
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Test the application in your browser" -ForegroundColor White
    Write-Host "  2. Open VS Code: code ." -ForegroundColor White
    Write-Host "  3. Follow exercises in: EVENT-APP-EXERCISES.md" -ForegroundColor White
    Write-Host ""
    Write-Host "Server is running in the other PowerShell window." -ForegroundColor Yellow
    Write-Host "Keep it open while working on exercises!" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "  X Server failed to start within 60 seconds" -ForegroundColor Red
    Write-Host "Check the server window for errors" -ForegroundColor Yellow
}

Read-Host "Press Enter to close this window"
