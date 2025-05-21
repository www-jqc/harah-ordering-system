@echo off
echo Starting Harah Mobile App Environment...

echo Starting WebSocket Server...
start cmd /k "cd /d %~dp0 && node websocket_server.js"

echo.
echo Starting Flutter App...
cd harah_mobile
flutter run -d chrome

echo.
echo Done!
pause 