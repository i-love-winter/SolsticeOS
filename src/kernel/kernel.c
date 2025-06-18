#include "include/printf.h"
#include "include/io.h"
#include "gdt/gdt.h"

#define SERIAL_PORT 0x3F8 // COM1

void init_serial() {
    outb(SERIAL_PORT + 1, 0x00); // Disable interrupts
    outb(SERIAL_PORT + 3, 0x80); // Enable DLAB to set baud rate
    outb(SERIAL_PORT + 0, 0x03); // Set divisor to 3 (38400 baud)
    outb(SERIAL_PORT + 1, 0x00);
    outb(SERIAL_PORT + 3, 0x03); // 8 bits, no parity, one stop bit
    outb(SERIAL_PORT + 2, 0xC7); // Enable FIFO, clear, set 14-byte threshold
    outb(SERIAL_PORT + 4, 0x0B); // IRQs enabled, RTS/DSR set
}

void _putchar(char c) {
    // Wait until the transmit buffer is empty, then write the character.
    while ((inb(SERIAL_PORT + 5) & 0x20) == 0);
    outb(SERIAL_PORT, c);
}

void vga_print(const char *str) {
    volatile unsigned short *vidmem = (unsigned short *)0xB8000; // VGA text buffer
    int row = 0, col = 0;

    while (*str) {
        if (*str == '\n') {
            row++; // Move down a row
            col = 0; // Reset column position
            vidmem = (volatile unsigned short *)0xB8000 + row * 80; // Move to start of next row
        } else {
            vidmem[col++] = (*str & 0xFF) | (0x07 << 8); // White text on black
        }
        str++;
    }
}

int main() {
    init_serial();
    initGdt();
    printf("GDT initialised \n");
    _putchar('>'); // just some testing, can't remember why I did this but it must be important ^_^
    vga_print("###############\n"
              "# Solstice OS #\n"
              "###############\n"
              "\n"
              "$sh1.1: ");
  

    while (1) {}
    return 1;
}


