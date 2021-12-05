@echo off
cd C:\ProgramData
if not exist batls md batls
cd batls
:main
cls
echo.
echo [1] Sign up
echo [2] Log in
set /p select=- 
if %select%==1 goto signup
if %select%==2 goto login
goto main

:signup
cls
echo.
set /p tempo= [New username]
if exist %temp%.batls goto main
set /p tempt= [New password]
echo %tempt%>%tempo%.batls
goto main