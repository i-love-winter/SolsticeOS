# Makefile for "This OS Needs a Name"

BUILD_DIR := $(shell pwd)/build

CC       := i386-elf-gcc
NASM     := nasm
OBJCOPY  := i386-elf-objcopy

LIBGCC   := $(shell i386-elf-gcc -print-libgcc-file-name)

CFLAGS   := -ffreestanding -m32 -g -I src/kernel/include
LDFLAGS  := -ffreestanding -m32 -g -nostdlib -nostartfiles -Ttext 0x1000

ASMFLAGS    := -f elf
BINASMFLAGS := -f bin

PRINTF_OBJ       := build/printf.o
KERNEL_OBJ       := build/kernel.o
KERNEL_ENTRY_OBJ := build/kernel_entry.o
ZEROES_BIN       := build/zeroes.bin
BOOT_BIN         := build/boot.bin

KERNEL_ELF       := build/complete_kernel.elf
KERNEL_BIN       := build/complete_kernel.bin
EVERYTHING_BIN   := build/everything.bin
FINAL_IMG        := "build/This\ OS\ Needs\ a\ Name.bin"

all: $(FINAL_IMG)

clean:
	@rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(ZEROES_BIN): src/other/zeroes.asm | $(BUILD_DIR)
	$(NASM) $(BINASMFLAGS) $< -o $@

$(BOOT_BIN): src/bootloader/boot.asm | $(BUILD_DIR)
	$(NASM) $(BINASMFLAGS) $< -o $@

$(PRINTF_OBJ): src/kernel/include/printf.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "Printf object created"

$(KERNEL_OBJ): src/kernel/kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "Kernel object created"

$(KERNEL_ENTRY_OBJ): src/kernel/kernel_entry.asm | $(BUILD_DIR)
	$(NASM) $(ASMFLAGS) $< -o $@
	@echo "Kernel entry object created"

$(KERNEL_ELF): $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ) $(PRINTF_OBJ) | $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBGCC)
	@echo "Kernel and kernel entry linked"

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

$(EVERYTHING_BIN): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $@

$(FINAL_IMG): $(EVERYTHING_BIN) $(ZEROES_BIN)
	cat $(EVERYTHING_BIN) $(ZEROES_BIN) > "$(FINAL_IMG)"
	@echo "Final disk image created: $(FINAL_IMG)"
