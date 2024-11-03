# MandelBOOT
MandelBOOT is a simple demo program that displays a Mandelbrot Set at boot using VGA video mode 0x13.

![MandelBOOT Preview](https://github.com/user-attachments/assets/cccaf921-94bd-4756-8374-c698deaef749)

## System Requirements 
- 386 Processor with 387 FPU or above
* This was based on testing where for some reason the 8086 and 286 (including their FPUs) shows a black screen.
- VGA Display Adapter
- Legacy Boot

## Assembling and Making MandelBOOT Bootable
MandelBOOT was assembled using [Netwide Assembler](https://www.nasm.us/) on both Windows and Linux systems; be sure to set up this software first. To assemble mandelboot.asm and get a disk image, use the command `nasm -f bin mandelboot.asm -o mandelboot.img`. Once done, it is possible to use dd to write it to physical media such as a USB flash drive or even a floppy disk. For use with a virtual machine instead, mandelboot.img can be used just like any other floppy disk image.

## Credits and Resources
I want to highly recommend [Daedalus Community's series on building an x86 operating system](https://www.youtube.com/playlist?list=PLm3B56ql_akNcvH8vvJRYOc7TbYhRs19M), as that is where I found some useful information on setting up the bootloader and how to assemble the file to be used as a disk image (not to mention it serves as a great place to start off building an operating system). Two more resources that proved to be a big help are [Ralph Brown's Interrupt List](http://www.ctyme.com/rbrown.htm) for a list of BIOS interrupts, and an [x86 Assembly Reference List](https://c9x.me/x86/) found at c9x.me. 
