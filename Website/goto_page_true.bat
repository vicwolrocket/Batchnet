::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFD9VaxaHPX+bArgV5sv65O+7hkIeQe86dpvI5pmPM/QW+AXGdIIu3kZUnd8bAwlTQiWubBw9vWt+sWuROPiMsgjkdVyb805+Hn1x5w==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
color 97
title Batchnet By Victor Wolmarans: loading website
for /f "Delims=" %%a in (goto_page.txt) do (

set link=%%a

)

type logo.txt
echo.
echo Going To https://%link%.batch
powershell -Command "Invoke-WebRequest pastebin.com/raw/%link% -Outfile page.bat"
if %errorlevel%==0 goto continue
:error
cls
echo.
echo Sorry, we could not go to the webpage you we're looking for
echo.
:error2
goto error2

:continue
cls
color 0F
title https://%link%.batch
page.bat