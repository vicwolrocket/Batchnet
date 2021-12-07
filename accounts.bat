@echo off
cd C:\
if not exist bna md bna
cd bna
:menu
cls
echo.
echo [1] Log in
echo [2] Sign up
echo.
set /p choice=-
if %choice%==1 goto login
if %choice%==2 goto signup
goto menu

:signup
cls
%extd% /inputbox "Sign up" "Type in your new username please" ""
set username=%result%
if "%result%"=="" (
  %extd% /messagebox "Uh oh!" "Invalid username!"
  goto menu
)
if exist %result% (
  %extd% /messagebox "Uh oh!" "User already exists!"
  goto menu
)
:signup2
%extd% /inputbox "Sign up" "Type in your new password please" ""
echo %result%>temp.txt
%extd% /sha1 temp.txt
set password=%result%
del temp.txt
echo %password%>%username%
cls
echo.
echo Account created succesfullt!
pause>nul
goto menu

:login
cls
%extd% /inputbox "Log in" "Type in your username" ""
set username=%result%
if "%result%"=="" (
  %extd% /messagebox "Uh oh!" "Invalid username!"
  goto menu
)
if not exist %result% (
  %extd% /messagebox "Uh oh!" "This user doesn't exist"
  goto menu
)
:login2
%extd% /inputbox "Log in" "Type in your password" ""
echo %result%>temp.txt
set /p realpass=<%username%
%extd% /sha1 temp.txt
del temp.txt
if %result%==%realpass% goto success
goto login2


:success
cls
echo.
echo Congats! You signed in!
pause>nul
