@echo off
chcp 65001 >nul
title Windows 11 Search Speedup

:: Admin check
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] This script must be run as Administrator.
    echo [!] Right-click -^> "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo ========================================
echo   Windows 11 Search Speedup
echo ========================================
echo.
echo This script will:
echo   - Disable web search suggestions
echo   - Disable Bing / Cortana cloud search
echo   - Disable Search Highlights
echo   - Remove menu animation delay
echo   - Rebuild the SearchHost cache folder
echo   - Restart search services
echo.
pause

echo.
echo [1/6] Disabling web search suggestions...
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul

echo [2/6] Disabling Bing / Cortana / cloud search...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v IsMSACloudSearchEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v IsAADCloudSearchEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f >nul

echo [3/6] Disabling Search Highlights...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" /v ShowDynamicContent /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul

echo [4/6] Removing menu animation delay...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul

echo [5/6] Backing up SearchHost cache folder...
set "SEARCHPKG=%LOCALAPPDATA%\Packages\Microsoft.BingSearch_8wekyb3d8bbwe"
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
timeout /t 2 /nobreak >nul
if exist "%SEARCHPKG%" (
    if exist "%SEARCHPKG%.bak" rmdir /s /q "%SEARCHPKG%.bak" >nul 2>&1
    ren "%SEARCHPKG%" "Microsoft.BingSearch_8wekyb3d8bbwe.bak" >nul 2>&1
    if exist "%SEARCHPKG%" (
        echo     [!] Folder could not be renamed ^(in use^) - skipping
    ) else (
        echo     [OK] Folder backed up as Microsoft.BingSearch_8wekyb3d8bbwe.bak
    )
) else (
    echo     [i] Folder not found - skipping
)

echo [6/6] Restarting search services and shell...
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
echo   DONE
echo ========================================
echo.
echo The first click may take 1-2 seconds while SearchHost
echo cold-starts. Subsequent searches should open instantly.
echo.
echo To revert changes: run undo-search.bat
echo.
pause
