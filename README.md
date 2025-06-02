# SolsticeOS

[yes the name was inspired by oneshot, absolutely fire game, buy it now, but if you use linux then get wme](https://store.steampowered.com/app/420530/OneShot/)

I'm using my own bootloader, made from scratch in ASM (x86).
I believe it is currently in 32 bit protected mode, please correct me if I'm wrong.
I am using the printf function here  -> [A simple printf implimentation](https://github.com/mpaland/printf/tree/master).

Spoiler: It was NOT SIMPLE to setup for my kernel, it took literal weeks of struggle, but it's working now!

To run, download the files and run:

  make clean
  
  make
  
  qemu-system-i386 -drive format=raw,file=build/SolsticeOS.bin -serial stdio

