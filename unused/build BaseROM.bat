@echo off
asm68k.exe /p BaseROM.asm, BaseROM.bin
if  errorlevel 1 PAUSE
else EXIT /B
