<# :
@echo off
title DFLU - DiscordFixLoopUpdate
color 0F
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
echo.
pause
goto :eof
#>

Clear-Host
$Host.UI.RawUI.WindowTitle = "DFLU - "

$bgBrand = "Cyan"
$fgBrand = "Black"
$cMain = "Cyan"
$cSuccess = "Green"
$cWarn = "Yellow"
$cError = "Red"
$cDim = "DarkGray"

Write-Host ""
Write-Host "  DFLU v2.0  " -BackgroundColor $bgBrand -ForegroundColor $fgBrand -NoNewline
Write-Host "  Discord Fix Loop Update`n" -ForegroundColor $cMain

function Write-Step {
    param($text)
    Write-Host "  ► " -ForegroundColor $cMain -NoNewline
    Write-Host $text -ForegroundColor White
}

function Write-Done {
    param($text)
    Write-Host "  √ " -ForegroundColor $cSuccess -NoNewline
    Write-Host $text -ForegroundColor $cSuccess
}

function Write-Warn {
    param($text)
    Write-Host "  ! " -ForegroundColor $cWarn -NoNewline
    Write-Host $text -ForegroundColor $cWarn
}

function Prompt-User {
    param($text)
    Write-Host ""
    Write-Host "  ? " -ForegroundColor $cMain -NoNewline
    Write-Host $text -ForegroundColor White -NoNewline
    Write-Host " [Y/n] " -ForegroundColor $cDim -NoNewline
    $ans = Read-Host
    if ([string]::IsNullOrWhiteSpace($ans)) { return $true }
    return $ans -match "^[Yy]"
}

# 1. Path
Write-Step "Checking Discord installation path..."
$discordPath = "$env:LOCALAPPDATA\Discord"
if (-not (Test-Path $discordPath)) {
    Write-Host "  X Discord not found at $discordPath" -ForegroundColor $cError
    exit
}
Write-Done "Located at $discordPath"

# 2. Process check
$discordProcs = Get-Process -Name "Discord", "Update" -ErrorAction SilentlyContinue
if ($discordProcs) {
    Write-Warn "Discord processes are running and might lock files."
    if (Prompt-User "Kill background processes?") {
        $discordProcs | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Done "Processes terminated."
    }
}

# 3. Version check
$appFolders = Get-ChildItem -Path $discordPath -Directory -Filter "app-*" | Where-Object Name -Match "^app-\d+\.\d+\.\d+$" | Sort-Object Name -Descending
if ($appFolders.Count -lt 2) {
    Write-Host "  X Need at least 2 versions to fix." -ForegroundColor $cError
    exit
}
$latest = $appFolders[0]
$previous = $appFolders[1]

Write-Host ""
Write-Host "    TARGET  " -BackgroundColor $cError -ForegroundColor Black -NoNewline
Write-Host " $($latest.Name) (Broken)" -ForegroundColor White
Write-Host "    SOURCE  " -BackgroundColor $cSuccess -ForegroundColor Black -NoNewline
Write-Host " $($previous.Name) (Working Backup)" -ForegroundColor White
Write-Host ""

# 4. Fix
Write-Step "Applying surgical overwrite..."
Start-Sleep -Milliseconds 600
try {
    Copy-Item -Path "$($previous.FullName)\*" -Destination "$($latest.FullName)" -Recurse -Force -ErrorAction Stop
    Write-Done "Discord core files restored successfully."
} catch {
    Write-Host "  X Failed to copy files. Close Discord manually." -ForegroundColor $cError
    exit
}

# 5. Cleanup
if (Prompt-User "Clean up old garbage folders to free up space?") {
    $deletedCount = 0
    $allFolders = Get-ChildItem -Path $discordPath -Directory -Filter "app-*" | Sort-Object Name -Descending
    foreach ($bad in ($allFolders | Where-Object Name -Match "_bad")) {
        Remove-Item -Path $bad.FullName -Recurse -Force -ErrorAction SilentlyContinue
        $deletedCount++
    }
    $standardFolders = $allFolders | Where-Object Name -Match "^app-\d+\.\d+\.\d+$"
    if ($standardFolders.Count -gt 2) {
        for ($i = 2; $i -lt $standardFolders.Count; $i++) {
            Remove-Item -Path $standardFolders[$i].FullName -Recurse -Force -ErrorAction SilentlyContinue
            $deletedCount++
        }
    }
    Write-Done "Removed $deletedCount junk folder(s)."
}

# 6. Cache
if (Prompt-User "Clear Discord Cache (prevents grey screens)?") {
    $roamingPath = "$env:APPDATA\discord"
    $cachePaths = @("$roamingPath\Cache", "$roamingPath\Code Cache", "$roamingPath\GPUCache")
    foreach ($cp in $cachePaths) {
        if (Test-Path $cp) { Remove-Item -Path $cp -Recurse -Force -ErrorAction SilentlyContinue }
    }
    Write-Done "Cache annihilated."
}

# 7. Launch
if (Prompt-User "Launch Discord now?") {
    $updateExe = "$discordPath\Update.exe"
    if (Test-Path $updateExe) {
        Start-Process -FilePath $updateExe -ArgumentList "--processStart Discord.exe"
        Write-Done "Launching signal sent."
    } else {
        $discordExe = "$($latest.FullName)\Discord.exe"
        if (Test-Path $discordExe) {
            Start-Process -FilePath $discordExe
            Write-Done "Launching signal sent."
        }
    }
}

Write-Host "`n  ======================= DONE =======================`n" -ForegroundColor $cDim
