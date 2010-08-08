; Copyright 2010 Curtis McEnroe <programble@gmail.com>
;
; This file is part of OSDevSK.
;
; OSDevSK is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; OSDevSK is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with OSDevSK.  If not, see <http://www.gnu.org/licenses/>.

global loader
extern kmain ; Defined in main.c

; Multiboot Header
MODULEALIGN equ 1<<0
MEMINFO equ 1<<1
FLAGS equ MODULEALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

section .mbheader
align 4
MultiBootHeader:
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .text

STACKSIZE equ 0x4000

loader:
    mov esp, stack+STACKSIZE ; Stack setup
    push eax ; Multiboot magic
    push ebx ; Miltiboot info

    call kmain ; Call C kernel

    cli

hang:
    hlt
    jmp hang

section .bss
align 4
stack:
    resb STACKSIZE
