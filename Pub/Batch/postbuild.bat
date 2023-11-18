rem batch script code is proccessed by the command interpreter(cmd.exe) app 
echo "Starting post build processes"

echo The path to the curent batch file is: %~dp0

for %%i in ("%~dp0\..") do set parent=%%~dpi

echo "parent: " %parent% 

@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

echo fullstamp: "%fullstamp%"

echo "Begin zip backup"

rem for some strange reason there is a space at the end of the parent var
rem so we use ": =" to remove the white space, don't know how the space gets there tho

echo "%parent%Pub\publish.zip"

echo f | xcopy /f /y "%parent%Pub\publish.zip"  "%parent%Pub\%fullstamp%.zip"

echo "End zip backup"

echo "Begin create new zip file"

set "zippath=%parent%Pub\publish.zip"

echo zippath: "%zippath%"

del /f /q "%zippath%"

powershell -Command "Compress-Archive -Path %parent%bin\Debug\net6.0\* -DestinationPath %parent%Pub\publish.zip"

echo "End create new zip file"

echo "zip complete."