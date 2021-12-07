@echo off
cd C:\
if not exist batchnet md batchnet
cd batchnet
if not exist ift.rar powershell -Command "Invoke-WebRequest https://github.com/vicwolrocket/Batchnet/blob/main/if.rar?raw=true -Outfile ift.rar"
md mainfiles
powershell -Command "Expand-Archive ift.rar"