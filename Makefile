CC=gcc
ASM=nasm
LD=ld

CINCLUDES=-Iinclude/
CWARNINGS=-Wall -Wextra
CFLAGS=-m32 -std=c99 -nostdlib -nostartfiles -nodefaultlibs -nostdinc -ffreestanding -fno-builtin $(CWARNINGS) $(CINCLUDES)
DFLAGS=-g -DDEBUG -O0

AFLAGS=-f elf

LDFLAGS=-melf_i386 -nostdlib -T build/linker.ld

CSOURCES:=$(wildcard src/*.c)
COBJECTS:=$(CSOURCES:%.c=%.o)

ASOURCES:=$(wildcard src/*.asm)
AOBJECTS:=$(ASOURCES:%.asm=%.ao)

KERNEL=kernel.elf

STAGE2=build/stage2_eltorito
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
