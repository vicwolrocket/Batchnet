::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFD9VaxaHPX+bArgV5sv65O+7hkIKWu4weYvI5pCaIeYS5krqZplg93ReisQFCFZ0cR6nZx87uSNgpGuSJMKO/QbiRSg=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
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
::Zh4grVQjdCyDJGyX8VAjFD9VaxaHPX+bArgV5sv65O+7hkIeQe86dpvI5pmPM/QW+AXGdIIu3kZUnd8bAwlTQjCqegw8p2tW9izTY4eeuhuoBE2R4ys=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
color 70
title The Batch Network By Victor Wolmarans

:menu
type logo.txt
echo.
echo.
echo.
echo Welcome To The Batchnet!
echo What do you want to do?
echo 1. Go to a website
echo 2. Clear downloads
set /p choice=-
if %choice%==1 goto website
if %choice%==2 goto downloads

:website
cls
echo Please Type In The Websites ID:
set /p page=-
if NOT EXIST Website md Website
cls
color CF
echo.
echo WARNING! SOME WEBSITES COULD HAVE MALICOUS FILES IN THEM
echo IF YOU GET INFECTED WITH A VIRUS I'M NOT RESPONSIBLE
pause
cd Website
echo ERROR>page.bat
call goto_page.bat %page%


:downloads
cd website
del /Q downloads
cls
echo Downloads cleared! :)
echo.
goto menu