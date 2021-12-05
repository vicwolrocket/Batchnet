@echo off
color 97
title Batchnet By Victor Wolmarans: loading website
for /f "Delims=" %%a in (goto_page.txt) do (

set link=%%a

)

type logo.txt
echo.
echo Going To %link%
if not "%link:~-4%" neq ".bnc" (
  powershell -Command "Invoke-WebRequest %link% -Outfile website.zip"
  goto checkvalid
)
cd website
powershell -Command "Invoke-WebRequest %link% -Outfile page.bat"


:checkvalid

if %errorlevel%==0 goto continue
:error
powershell -Command "Invoke-WebRequest pastebin.com/raw/qzVNBHJj -Outfile mrfluffy.txt"
cls
color 76
echo.
echo Sorry, we could not go to the webpage you we're looking for...
echo Mr. Fluffy is here to help :D
echo.
type mrfluffy.txt
echo.
echo.
echo.
echo.
echo.
cd..
main.bat

:continue
if not "%link:~-4%" neq ".bnc" (
  decompilezip.bat
  goto exit
)
color 0f
cls
color 0F
title %link%
mode con:cols=100 lines=25
page.bat
cd..
start main.bat
:exit