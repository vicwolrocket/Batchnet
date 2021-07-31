@echo off
for /f "Delims=" %%a in (goto_page.txt) do (

set link=%%a

)

if NOT EXIST downloads md downloads
cd downloads
