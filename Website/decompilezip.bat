@echo off
if not exist website md website
del website /q
powershell -Command "Expand-Archive -LiteralPath website.zip -DestinationPath website"
cd website
set /p i=<config
if "%i:~-4%" neq ".bat" goto warn
:execute
color 0f
%i%
:warn
color 0c
echo.
echo -------------- Warning! ------------------
echo This .bnc file is configured to open a file
echo that is not a batch file. This may be a
echo virus, some malware or ransomware.
echo.
echo TYPE IN "RUN" TO RUN THE FILE
echo AT YOUR OWN RISK (Use capital letters)
set /p do=Wanna run it? 
if do=="RUN" goto execute