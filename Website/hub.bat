@echo off
title BatchNet Games
:menu
cls
echo.
echo Welcome to BatchNet Games!
echo.
echo What game would you like
echo        to play?
echo.
echo     [1] CMDRUNNER
echo     [2] Blockout
echo.
set /p choice=-
cd..
if %choice%==1 (
  echo https://download1475.mediafire.com/ni7edhqnfy5g/gq9mitrwlsmnv52/cmdrunner.bnc>goto_page.txt
  goto_page_true.exe
)
if %choice%==2 (
  echo https://download1509.mediafire.com/jlerc158scqg/bwtszfigvyg99we/blockout.bnc>goto_page.txt
  goto_page_true.exe
)
cd Website
goto menu