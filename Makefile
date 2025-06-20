all: clean zeroes includes kernel boot image

clean:
	rm -rf build
	mkdir build

zeroes:
	nasm src/other/zeroes.asm -f bin -o build/zeroes.bin

includes:
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/include/printf.c -o build/printf.o
	echo "Printf object created"
	nasm src/kernel/gdt/gdt.s -f elf -o build/gdts.o
	i386-elf-gcc -ffreestanding -m32 -g -nostdlib -nostartfiles -Ttext 0x1000 -o build/gdt.o build/gdts.o src/kernel/gdt/gdt.c
	echo "GDT object created"
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/utils/utils.c -o build/utils.o
	echo "Utils object created"


kernel:
	i386-elf-gcc -ffreestanding -m32 -g -c src/kernel/kernel.c -o build/kernel.o
	echo "Kernel object created"
	nasm src/kernel/kernel_entry.asm -f elf -o build/kernel_entry.o 
	echo "Kernel entry object created"
	i386-elf-gcc -ffreestanding -m32 -g -nostdlib -nostartfiles -Ttext 0x1000 -o build/complete_kernel.elf build/kernel_entry.o build/kernel.o build/printf.o build/gdt.o build/utils.o $(shell i386-elf-gcc -print-libgcc-file-name)
	echo "Kernel linked to kernel entry and includes"

boot:
	nasm src/bootloader/boot.asm -f bin -o build/boot.bin

image:
	i386-elf-objcopy -O binary $< build/complete_kernel.elf
	cat build/boot.bin build/complete_kernel.elf > build/everything.bin
	cat build/everything.bin build/zeroes.bin > "build/SolsticeOS.bin"
	echo "Final disk image created: build/SolsticeOS.iso"
	mkisofs -o build/SolsticeOS.iso build/SolsticeOS.bin
