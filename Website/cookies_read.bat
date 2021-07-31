@echo off
if NOT EXIST cookies md cookies
cd cookies
for /f "Delims=" %%a in (%1.txt) do (

set cookie=%%a

)
cd..