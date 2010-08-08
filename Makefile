# Copyright 2010 Curtis McEnroe <programble@gmail.com>
#
# This file is part of OSDevSK.
#
# OSDevSK is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# OSDevSK is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OSDevSK.  If not, see <http://www.gnu.org/licenses/>.

CC=clang
ASM=nasm
LD=ld

CINCLUDES=-Iinclude/
CWARNINGS=-Wall -Wextra
CFLAGS=-m32 -std=c99 -nostdlib -nostartfiles -nodefaultlibs -nostdinc -ffreestanding -fno-builtin $(CWARNINGS) $(CINCLUDES)
DFLAGS=-g -DDEBUG -O0

AFLAGS=-f elf

LDFLAGS=-melf_i386 -nostdlib -T linker.ld

CSOURCES:=$(wildcard src/*.c)
COBJECTS:=$(CSOURCES:%.c=%.o)

ASOURCES:=$(wildcard src/*.asm)
AOBJECTS:=$(ASOURCES:%.asm=%.ao)

KERNEL=kernel.elf

STAGE2=/usr/lib/grub/i386-pc/stage2_eltorito
GENISOIMAGE=genisoimage

ISO=osdevsk.iso

all: $(ISO)

$(ISO): $(KERNEL)
	mkdir -p iso/boot/grub
	cp $(STAGE2) iso/boot/grub/stage2_eltorito
	cp $(KERNEL) iso/boot/$(KERNEL)
	echo "default 0" > iso/boot/grub/menu.lst
	echo "timeout 3" >> iso/boot/grub/menu.lst
	echo "title OS Dev Starter Kit Kernel" >> iso/boot/grub/menu.lst
	echo "kernel /boot/$(KERNEL)" >> iso/boot/grub/menu.lst
	$(GENISOIMAGE) -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -o $(ISO) iso/

$(KERNEL): $(CSOURCES) $(ASOURCES) $(COBJECTS) $(AOBJECTS)
	$(LD) $(LDFLAGS) $(AOBJECTS) $(COBJECTS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.ao: %.asm
	$(ASM) $(AFLAGS) -o $@ $<

debug:
	@$(MAKE) $(MFLAGS) CFLAGS="$(CFLAGS) $(DFLAGS)"

qemu: $(ISO)
	qemu -cdrom $(ISO)

qemu-gdb: debug $(ISO)
	qemu -s -S -cdrom $(ISO)

clean:
	rm -f $(KERNEL)
	rm -f $(ISO)
	rm -f $(COBJECTS)
	rm -f $(AOBJECTS)
	rm -rf iso/

distclean: clean
	rm -f *~
	rm -f src/*~
	rm -f include/*~

check-syntax:
	$(CC) $(CFLAGS) -fsyntax-only $(CHK_SOURCES)

.PHONY: clean distclean check-syntax debug qemu qemu-gdb
