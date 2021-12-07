@echo off
set linkt=%1
cd..
set tmp=%cd%
cd website
echo %tmp%>tmp.txt
cls
title The Batch Network by vicwolrocket: loading website
echo %1>goto_page.txt
goto_page_true.exe
set linkt=%linkt:.bat=%
set linkt=%linkt:.bnc=%
set linkt=%linkt:https://=%
set linkt=%linkt:http://=%
echo %linkt%>>history.txt
exit