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

#include <multiboot.h>

void kmain(multiboot_header *multiboot, unsigned int magic)
{
    if (magic != MULTIBOOT_BOOTLOADER_MAGIC)
    {
        /* Kernel was not loaded with a multiboot compliant bootloader, halt */
        __asm__ __volatile("cli; hlt;");
    }
    
    /* Code your kernel here */
    
    /* This function should never return */
    while (1) __asm__ __volatile("hlt");
}
