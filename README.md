# SolsticeOS

[yes the name was inspired by oneshot, absolutely fire game, buy it now](https://store.steampowered.com/app/420530/OneShot/)

I'm using my own bootloader, made from scratch in ASM (x86).
I believe it is currently in 32 bit protected mode, please correct me if I'm wrong.
I am using the printf function here  -> [A simple printf implimentation](https://github.com/mpaland/printf/tree/master).

I'm trying to get my IDT working at the moment

To run, download the files and run:
make

qemu-system-i386 -drive format=raw,file=build/SolsticeOS.bin -serial stdio


If you want to use my project or some part of it in your project, please link it on your project
