@echo off

setlocal
SET PATH=.\gcc\bin;%PATH%

nasm\nasm -f elf32 new1.asm
gcc -o main.exe main.c new1.o AsmMath.h
:: ponha aqui para compilar

main.exe
