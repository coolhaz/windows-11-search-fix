@echo off
chcp 65001 >nul
title Windows 11 Search - Restore Defaults

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] This script must be run as Administrator.
    pause
    exit /b 1
)

echo ========================================
echo   Windows 11 Search - Restore Defaults
echo ========================================
echo.
echo All changes will be reverted.
echo.
pause

echo.
echo [1/5] Removing registry values...
reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v IsMSACloudSearchEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v IsAADCloudSearchEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /f >nul 2>&1

echo [2/5] Re-enabling Search Highlights...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" /v ShowDynamicContent /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f >nul 2>&1

echo [3/5] Restoring default menu delay (400ms)...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul

echo [4/5] Restoring SearchHost cache folder...
set "SEARCHPKG=%LOCALAPPDATA%\Packages\Microsoft.BingSearch_8wekyb3d8bbwe"
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
timeout /t 2 /nobreak >nul
if exist "%SEARCHPKG%.bak" (
    if exist "%SEARCHPKG%" rmdir /s /q "%SEARCHPKG%" >nul 2>&1
    ren "%SEARCHPKG%.bak" "Microsoft.BingSearch_8wekyb3d8bbwe" >nul 2>&1
    echo     [OK] Old cache restored
) else (
    echo     [i] Backup folder not found - skipping
)

echo [5/5] Restarting services and shell...
net stop WSearch >nul 2>&1
net start WSearch >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe

echo.
echo ========================================
echo   DEFAULTS RESTORED
echo ========================================
echo.
pause
