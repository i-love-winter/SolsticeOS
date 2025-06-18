all: clean zeroes includes kernel boot image

clean:
	rm -rf build
	mkdir build

zeroes:
	nasm src/other/zeroes.asm -f bin -o build/zeroes.bin

includes:
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/include/printf.c -o build/printf.o
	echo "Printf object created"
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/gdt/gdt.c -o build/gdt.o
	echo "GDT object created"
	nasm -f elf src/kernel/gdt/gdt.s -o build/gdts.o
	echo "GDTS object created"


kernel:
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/kernel.c -o build/kernel.o
	echo "Kernel object created"
	nasm src/kernel/kernel_entry.asm -f elf -o build/kernel_entry.o 
	echo "Kernel entry object created"
	i386-elf-gcc -ffreestanding -m32 -g -nostdlib -nostartfiles -Ttext 0x1000 -o build/complete_kernel.elf build/kernel_entry.o build/kernel.o build/printf.o build/gdt.o build/gdts.o $(shell i386-elf-gcc -print-libgcc-file-name)
	echo "Kernel linked to kernel entry and includes"

boot:
	nasm src/bootloader/boot.asm -f bin -o build/boot.bin

image:
	i386-elf-objcopy -O binary $< build/complete_kernel.elf
	cat build/boot.bin build/complete_kernel.elf > build/everything.bin
	cat build/everything.bin build/zeroes.bin > "build/SolsticeOS.iso"
	echo "Final disk image created: build/SolsticeOS.iso"
	mkisofs -o SolsticeOS.iso build/SolsticeOS.bin
