@echo off
color 70
title The Batch Network By vicwolrocket

:menu
type logo.txt
echo.
echo.
echo.
echo Welcome To The Batchnet!
echo What do you want to do?
echo 1. Go to a website
echo 2. Clear downloads
echo 3. Commands
set /p choice=-
if %choice%==1 goto website
if %choice%==2 goto downloads
if %choice%==3 goto cmds

:website
cls
echo Please Type In The Websites URL:
set /p page=-
if NOT EXIST Website md Website
cls

cd Website
echo ERROR>page.bat
call goto_page.bat %page%


:downloads
cd website
del /Q downloads
cls
echo Downloads cleared! :)
echo.
cd..
goto menu


:cmds
cd Website
call goto_page pastebin.com/raw/djpf4t91