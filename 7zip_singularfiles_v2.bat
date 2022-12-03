@echo off
if exist "%programfiles%\7-Zip\7z.exe" set "_7zip=%programfiles%\7-Zip\7z.exe"&goto :next
if exist "%programfiles(x86)%\7-Zip\7z.exe" set "_7zip=%programfiles(x86)%\7-Zip\7z.exe"&goto :next
if exist "7z.exe" set "_7zip=7z.exe"&goto :next
title ERROR
echo THIS SCRIPT NEEDS 7zip&pause&exit

:next
rem //all files, no folders, minus batch script
REM dir /b /a:-d|(findstr /lv /c:"%~nx0")>temp.txt

set /a "_total_lines=-1"&set /a "_count_lines=0"
for /f "delims=" %%g in ('dir /b /a:-d') do set /a _total_lines+=1

if %_total_lines% equ 0 (
	title ERROR
	echo THERE ARE NO FILES&pause&exit 
)

if exist error.log del error.log
for /f "delims=" %%g in ('dir /b /a:-d^|findstr /lv /c:"%~nx0"') do (
	if exist "%%g" (
		"%_7zip%" a -spd -- "%%~ng.zip" "%%g"
		del "%%g"
		call :line_counter
	)else (
		(echo "%%g") >>error.log
	)
	cls
)

REM del temp.txt
title FINISHED
echo TOTAL FILES PROCESSED: %_count_lines%
if exist error.log (
	echo.
	echo ERRORS:
	type error.log

)
echo.
pause&exit

rem // ---------------------- end of script ------------------------------

:line_counter
set /a "_count_lines+=1"
set /a "_percent=(%_count_lines%*100)/%_total_lines%
title 7zip batch: %_count_lines% / %_total_lines% ^( %_percent% %% ^)
exit /b
