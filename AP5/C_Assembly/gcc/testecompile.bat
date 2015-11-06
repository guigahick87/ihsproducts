@echo off

setlocal
set PATH=C:\sandbox\c-asm\tdm-gcc\bin

@echo on

echo %PATH%

bin\gcc main.c -o programa.exe
