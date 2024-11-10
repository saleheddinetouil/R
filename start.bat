@echo off
setlocal enabledelayedexpansion

:: --- Variables --- 
set SERVER_NAME="Windows Server 2016 by @Davitt"
set ADMIN_PASSWORD="admin123"
set WALLPAPER_PATH="C:\Users\Public\Desktop\wallpaper.jpg" 
set NGROK_CONFIG_PATH="C:\Program Files\ngrok\ngrok.exe"
set NGROK_AUTH_TOKEN="2nRdX2lz14AAkLcOHd0lKCXFHR2_4CQr3QjdCrUYqR4sWh8VY"

:: ---  Delete Epic Games Launcher Shortcut --- 
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" 2>NUL

:: --- Set Server Comment --- 
net config server /srvcomment:"!SERVER_NAME!" 2>NUL

:: --- Disable Auto Tray --- 
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F 2>NUL

:: --- Set Wallpaper ---
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d "C:\Windows\System32\rundll32.exe user32.dll,UpdatePerUserSystemParameters !WALLPAPER_PATH!" 2>NUL

:: --- Create Administrator User --- 
net user administrator "!ADMIN_PASSWORD!" /add 2>NUL
net localgroup administrators administrator /add 2>NUL
net user administrator /active:yes 2>NUL

:: --- Delete Installer User --- 
net user installer /delete 2>NUL

:: --- Enable Disk Performance Monitoring ---
diskperf -Y 2>NUL

:: --- Start Audio Service ---
sc config Audiosrv start= auto 2>NUL
sc start audiosrv 2>NUL

:: --- Grant Admin Permissions ---
ICACLS C:\Windows\Temp /grant administrator:F 2>NUL
ICACLS C:\Windows\installer /grant administrator:F 2>NUL

:: ---  Ngrok Setup --- 
echo.
echo Setting up ngrok tunnel...
if exist "!NGROK_CONFIG_PATH!" (
  echo.
  echo ngrok found.
  echo.
  echo Starting ngrok...
  start "" "!NGROK_CONFIG_PATH!" authtoken "!NGROK_AUTH_TOKEN!"
  timeout /t 10 /nobreak >nul
  echo.
  echo Waiting for tunnel...
  timeout /t 10 /nobreak >nul
  echo.
  echo Retrieving public tunnel URL...
  echo Public Tunnel URL:
  !NGROK_CONFIG_PATH! status | findstr "Forwarding" > tunnel.txt
  set /p TUNNEL_URL=<tunnel.txt
  echo !TUNNEL_URL!
  echo.
) else (
  echo ngrok not found. Please install ngrok: https://ngrok.com/download
  echo.
)

:: --- Success Message ---
echo.
echo Server successfully configured!
echo.
echo IP: %COMPUTERNAME%
echo Username: administrator
echo Password: !ADMIN_PASSWORD!
echo.
echo Please log in to your RDP!
echo.
ping -n 10 127.0.0.1 >nul

endlocal
