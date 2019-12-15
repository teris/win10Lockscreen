@echo off
whoami /groups | find "S-1-16-12288" > nul
if %errorlevel% == 0 (
	goto check
)

if %errorlevel% == 1 (
	echo Bitte Aufuehren als Administrator!
goto exit
)

:check
set value=
for /f "tokens=3 delims= " %%i in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization /v NoLockScreen /t REG_DWORD ^| findstr /i "REG_DWORD" ') do set value=%%i

if "%value%" EQU "" (
	echo NoLockScreen ist noch nicht vorhanden
	goto menu
) else (
	echo NoLockScreen ist bereits vorhanden...
	if %value% == 0x1 echo ...und aktiviert.
	if %value% == 0x0 echo ...aber nicht aktiviert.
	goto menu
)

:on
	echo _____________________________________________________
	echo NoLockScreen wird Aktiviert
	reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization /v NoLockScreen /d 1 /f /t REG_DWORD
	echo NoLockScreen wurde erfolgreich geaendert mit dem Wert 1!
	echo Bitte den Computer neustarten!
	goto menu

:off
	echo _____________________________________________________
	echo NoLockScreen wird deaktiviert
	reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization /v NoLockScreen /d 0 /f /t REG_DWORD
	echo NoLockScreen wurde erfolgreich geaendert mit dem Wert 0!
	echo Bitte den Computer neustarten!
	goto menu

:exit
	echo _____________________________________________________
	echo Programm wird beendet.
	pause
	exit

:menu
	echo _____________________________________________________
	echo Menu: 
	echo 1 = Aktivieren
	echo 2 = Deaktivieren
	echo 3 = Erneut testen
	echo q = Beenden
	echo r = Neustarten

	echo Option jetzt eingeben: 
	set /p Option=
	if %Option% == 1 goto on
	if %Option% == 2 goto off
	if %Option% == 3 goto check
	if %Option% == q goto exit
	if %Option% == r shutdown -r -t 0


