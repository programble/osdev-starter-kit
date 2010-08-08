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
ENTRY (loader)
SECTIONS
{
  . = 0x00100000;
  /* You can use extern link_kernel_start in C to find where your kernel starts */
  link_kernel_start = .;

  /* Multiboot header must be in the first 4K of the kernel */
  .mbheader : {
    *(.mbheader)
  }

  .text : {
    *(.text)
  }

  .rodata ALIGN (0x1000) : {
    *(.rodata)
  }

  .data ALIGN (0x1000) : {
    *(.data)
  }

  .bss : {
    sbss = .;
    *(COMMON)
    *(.bss)
    ebss = .;
  }
  /* You can use extern link_kernel_end in C to find where your kernel ends */
  link_kernel_end = .;
}
