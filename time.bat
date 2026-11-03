@echo off
setlocal EnableExtensions EnableDelayedExpansion
:: ===== 한글 깨짐 방지 =====
:: 이 파일은 ANSI(CP949) 또는 UTF-8 BOM으로 저장 권장
chcp 949 >nul
title 한국 시간 동기화 도구
:: ===== 관리자 권한 자동 상승 =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 관리자 권한으로 다시 실행합니다...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
cls
echo ===================================
echo    한국 표준시(KST) 동기화 도구
echo ===================================
echo.
echo [1/5] 시간대를 한국 표준시(KST)로 설정 중...
tzutil /s "Korea Standard Time"
if %errorlevel% neq 0 (
    echo 시간대 설정에 실패했습니다.
    pause
    exit /b 1
)
echo 완료
echo.
echo [2/5] Windows 시간 서비스 설정 확인 중...
sc query w32time >nul 2>&1
if errorlevel 1 (
    echo   - 시간 서비스가 등록되어 있지 않아 다시 등록합니다...
    w32tm /register >nul 2>&1
    sc query w32time >nul 2>&1
    if errorlevel 1 (
        echo 시간 서비스 등록에 실패했습니다. 재부팅 후 다시 실행해 주세요.
        pause
        exit /b 1
    )
)
sc config w32time start= auto >nul 2>&1
echo 완료
echo.
echo [3/5] 시간 서비스 시작 중...
net start w32time >nul 2>&1
call :WAIT_RUNNING
if errorlevel 1 (
    echo 시간 서비스를 시작하지 못했습니다.
    pause
    exit /b 1
)
echo 완료
echo.
echo [4/5] 한국 NTP 서버로 동기화 설정 중...
w32tm /config /manualpeerlist:"time.windows.com,0x8 time.google.com,0x8 kr.pool.ntp.org,0x8" /syncfromflags:manual /update >nul 2>&1
if %errorlevel% neq 0 (
    echo 시간 서버 설정에 실패했습니다.
    pause
    exit /b 1
)
echo 완료
echo.
echo [5/5] 시간 동기화 시도 중...
set SYNC_OK=0
for /L %%i in (1,1,5) do (
    echo   - %%i번째 시도...
    w32tm /resync /rediscover >nul 2>&1
    if !errorlevel! equ 0 (
        set SYNC_OK=1
        goto :SYNC_DONE
    )
    net stop w32time >nul 2>&1
    net start w32time >nul 2>&1
    call :WAIT_RUNNING
)
:SYNC_DONE
echo.
if "%SYNC_OK%"=="1" (
    echo 동기화가 완료되었습니다.
) else (
    echo 자동 동기화에 실패했습니다.
    echo 그래도 시간대는 한국 표준시로 설정되었습니다.
    echo 현재 상태를 확인합니다...
)
echo.
echo 현재 시간:
time /t
echo 현재 날짜:
date /t
echo.
echo 상세 상태:
w32tm /query /status
echo.
pause
exit /b

:: ===== w32time 서비스가 RUNNING 상태가 될 때까지 최대 15초 대기 =====
:WAIT_RUNNING
for /L %%j in (1,1,15) do (
    sc query w32time | find "RUNNING" >nul && exit /b 0
    timeout /t 1 /nobreak >nul
)
exit /b 1
