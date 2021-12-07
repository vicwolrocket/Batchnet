@echo off
title Installing...
cd C:\
if not exist batchnet md batchnet
cd batchnet
del /q files.zip
powershell -Command "Invoke-WebRequest https://github.com/vicwolrocket/Batchnet/blob/main/if.zip?raw=true -Outfile files.zip"
rmdir /s /q files
copy Batchnet.exe c:\Users\%username%\Desktop\Batchnet.exe
powershell -Command "Expand-Archive files.zip"