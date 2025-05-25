make:
	nasm "src/zeroes.asm" -f bin -o "build/zeroes.bin"
	i386-elf-gcc -ffreestanding -m32 -g -c "src/kernel/kernel.c" -o "build/kernel.o"
	echo "Kernel object created"
	nasm "src/kernel_entry.asm" -f elf -o "build/kernel_entry.o"
	echo "Kernel entry object created"
	i386-elf-ld -o "build/complete_kernel.bin" -Ttext 0x1000 "build/kernel_entry.o" "build/kernel.o" --oformat binary
	echo "Kernel and kernel entry linked"
	nasm "src/bootloader/boot.asm" -f bin -o "build/boot.bin"
	echo "Boot binary created"
	cat "build/boot.bin" "build/complete_kernel.bin" > "build/everything.bin"
	cat "build/everything.bin" "build/zeroes.bin" > "build/This OS Needs a Name.bin"
