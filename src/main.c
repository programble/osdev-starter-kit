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
