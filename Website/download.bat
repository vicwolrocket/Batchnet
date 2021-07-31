@echo off
for /f "Delims=" %%a in (goto_page.txt) do (

set folder=%%a

)
if NOT EXIST downloads md downloads
cd downloads
powershell -Command "Invoke-WebRequest %1 -Outfile %2"
cd..
