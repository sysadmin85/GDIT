ECHO OFF
REM This script launched the Python script to parse the full struct into html to recreate worddocs from
REM sets a codepage so we can safely work with UTF-8
chcp 1252
cd ..\..\
REM run the python interpreter on the python script
collateral\tools\Python25\python.exe collateral\build\ActivityReport.py