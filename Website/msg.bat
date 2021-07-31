@echo off
for /f "Delims=" %%a in (goto_page.txt) do (

set link=%%a

)
echo x=msgbox("%1", 0+64, "https://%link%.batch")>msg.vbs
start msg.vbs