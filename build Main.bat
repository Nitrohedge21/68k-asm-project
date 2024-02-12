@echo off
asm68k.exe /p Main.asm, Main.bin
if  errorlevel 1 PAUSE
else EXIT /B
