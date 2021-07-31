@echo off
if NOT EXIST cookies md cookies
cd cookies
echo %2>%1.txt
cd..