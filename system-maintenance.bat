@echo off
REM written by Manuel Pollhammer
setlocal

REM Titel des Fensters setzen
title System Maintenance Tool

echo ================================
echo  System Maintenance Tool
echo ================================
echo.
echo Wählen Sie eine Option:
echo 1. Temporäre Dateien löschen
echo 2. Papierkorb leeren
echo 3. Systemlaufwerk auf Fehler prüfen
echo 4. Nicht benötigte Autostart-Programme deaktivieren
echo 5. Netzwerkverbindung prüfen
echo 6. Festplattenbelegung anzeigen
echo 7. DNS-Cache leeren
echo 8. Windows-Updates überprüfen
echo 9. Liste installierter Programme exportieren
echo 10. Beenden
echo.

REM Benutzereingabe einholen
set /p choice="Bitte eine Option wählen (1-10): "

REM Auswahl verarbeiten
if "%choice%"=="1" goto DeleteTempFiles
if "%choice%"=="2" goto EmptyRecycleBin
if "%choice%"=="3" goto CheckSystemDrive
if "%choice%"=="4" goto DisableStartupPrograms
if "%choice%"=="5" goto CheckNetworkConnection
if "%choice%"=="6" goto ShowDiskUsage
if "%choice%"=="7" goto FlushDNS
if "%choice%"=="8" goto CheckWindowsUpdates
if "%choice%"=="9" goto ExportInstalledPrograms
if "%choice%"=="10" goto End

echo Ungültige Auswahl, bitte erneut versuchen.
goto End

:DeleteTempFiles
echo Temporäre Dateien werden gelöscht...
del /s /q %temp%\*
echo Temporäre Dateien erfolgreich gelöscht.
goto End

:EmptyRecycleBin
echo Papierkorb wird geleert...
powershell -command "Clear-RecycleBin -Force"
echo Papierkorb erfolgreich geleert.
goto End

:CheckSystemDrive
echo Systemlaufwerk wird auf Fehler geprüft...
chkdsk C: /F
echo Überprüfung abgeschlossen.
goto End

:DisableStartupPrograms
echo Deaktivieren nicht benötigter Autostart-Programme...
echo.
echo Geben Sie die Namen der Autostart-Programme ein, die Sie deaktivieren möchten, getrennt durch Leerzeichen:
echo.
set /p programs="Programme eingeben: "
for %%i in (%programs%) do (
    echo Deaktiviere %%i...
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%i /f
)
echo Autostart-Programme erfolgreich deaktiviert.
goto End

:CheckNetworkConnection
echo Überprüfen der Netzwerkverbindung...
ping 8.8.8.8 -n 4
if %errorlevel%==0 (
    echo Netzwerkverbindung erfolgreich getestet.
) else (
    echo Netzwerkverbindung fehlgeschlagen. Bitte überprüfen Sie Ihre Verbindung.
)
goto End

:ShowDiskUsage
echo Anzeigen der Festplattenbelegung...
wmic logicaldisk get name,size,freespace,caption
goto End

:FlushDNS
echo DNS-Cache wird geleert...
ipconfig /flushdns
echo DNS-Cache erfolgreich geleert.
goto End

:CheckWindowsUpdates
echo Überprüfen auf Windows-Updates...
powershell -command "Get-WindowsUpdateLog"
echo Windows-Updates überprüft.
goto End

:ExportInstalledPrograms
echo Exportieren der Liste installierter Programme...
wmic product get name,version > "%userprofile%\Desktop\InstalledPrograms.txt"
echo Liste installierter Programme wurde auf dem Desktop gespeichert.
goto End

:End
echo.
echo Wartungsaufgaben abgeschlossen.
echo Drücken Sie eine beliebige Taste zum Beenden...
pause >nul

endlocal
