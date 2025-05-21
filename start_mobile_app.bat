@echo off
echo Starting Harah Mobile App Environment...
echo.

REM Make sure XAMPP is running
echo Checking XAMPP Services...
tasklist /FI "IMAGENAME eq httpd.exe" | find "httpd.exe" > nul
IF NOT ERRORLEVEL 1 (
  echo Apache is running...
) ELSE (
  echo WARNING: Apache does not appear to be running!
  echo Please start Apache in XAMPP Control Panel
)

tasklist /FI "IMAGENAME eq mysqld.exe" | find "mysqld.exe" > nul
IF NOT ERRORLEVEL 1 (
  echo MySQL is running...
) ELSE (
  echo WARNING: MySQL does not appear to be running!
  echo Please start MySQL in XAMPP Control Panel
)

echo.
echo Starting WebSocket Server...
start cmd /k "title WebSocket Server && node websocket_server.js"

echo.
echo Waiting for WebSocket server to initialize...
timeout /t 3 /nobreak > nul

echo.
echo Starting Flutter App...
cd harah_mobile
echo.
echo Login with:
echo   Username: clemens
echo   Password: 1234
echo.
flutter run -d chrome

echo.
echo Done!
pause 