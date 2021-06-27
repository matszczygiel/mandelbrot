#!/bin/env bash

nasm -f elf mandelbrot.asm
ld -m elf_i386 -s -o mandelbrot mandelbrot.o
