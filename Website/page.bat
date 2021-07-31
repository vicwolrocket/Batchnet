@echo off
color 71
echo Commands:
echo "call cookies_modify (name) (data)"
echo "call cookies_read (name)" The data will be stored in the variable called "cookie"
echo "call download (link)"
echo "call downloads_folder" this will redirect you to the downloads folder"
echo "call goto_page (website ID)"
:loop
goto loop