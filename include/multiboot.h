/*  Copyright 2010 Curtis McEnroe <programble@gmail.com>
 *
 *  This file is part of OSDevSK.
 *
 *  OSDevSK is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  OSDevSK is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with OSDevSK.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __MULTIBOOT_H__
#define __MULTIBOOT_H__

#define MULTIBOOT_HEADER_MAGIC 0x1BADB002
#define MULTIBOOT_BOOTLOADER_MAGIC 0x2BADB002

typedef struct
{
    unsigned int size;
    unsigned int base_addr;
    unsigned int base_addr_high;
    unsigned int length;
    unsigned int length_high;
    unsigned int type;
} mmap_field;

typedef struct module
{
    unsigned int start;
    unsigned int end;
    char * name;
    int reserved;
} module;

typedef struct
{
    unsigned int flags;
    unsigned int mem_lower;
    unsigned int mem_upper;
    unsigned int boot_device;
    char *cmdline;
    unsigned int mods_count;
    module *mods_addr;
    unsigned int syms[4];
    unsigned int mmap_length;
    mmap_field *mmap_addr;
    unsigned int drives_length;
    unsigned int *drives_addr;
    unsigned int config_table;
    char *bootloader_name;
    unsigned int apm_table;
    unsigned int vbe_control_info;
    unsigned int vbe_mode_info;
    unsigned short vbe_mode;
    unsigned short vbe_interface_seg;
    unsigned short vbe_interface_off;
    unsigned short vbe_interface_len;
    unsigned long long framebuffer_addr;
    unsigned int framebuffer_pitch;
    unsigned int framebuffer_width;
    unsigned int framebuffer_height;
    unsigned char framebuffer_bpp;
    unsigned char framebuffer_type;
    unsigned char color_info[6];
} multiboot_header;

#endif
