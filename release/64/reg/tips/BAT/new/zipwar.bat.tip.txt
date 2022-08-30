@echo off
echo current path ：%~f0
REM pause
cd /d %~dp0
@echo off

7z.exe a weilaix.7z weilaix.war