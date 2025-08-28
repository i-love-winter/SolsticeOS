# SolsticeOS (currently on hold while I'm working on another project atm)

I'm using my own bootloader, made from scratch in ASM (x86).
I believe it is currently in 32 bit protected mode, please correct me if I'm wrong.
I am using the printf function here  -> [A simple printf implimentation](https://github.com/mpaland/printf/tree/master).

I'm trying to get my IDT working at the moment, and struggling with getting a cross-compiler working again on my new arch install lol

To run, download the files and run:

make

qemu-system-i386 -drive format=raw,file=build/SolsticeOS.bin -serial stdio


If you want to use my project or some part of it in your project, please link it on your project
