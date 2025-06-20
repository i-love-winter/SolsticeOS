#include <stdint.h>
#include "gdt.h"

extern void gdt_flush(uint32_t);

struct gdt_entry_struct gdt_entries[5];
struct gdt_ptr_struct gdt_ptr;

void initGdt() {
  gdt_ptr.limit = (sizeof(struct gdt_entry_struct) * 5) -1;
  gdt_ptr.base = (uint32_t)&gdt_entries;

  setGdtGate(0,0,0,0,0); // null segment
  setGdtGate(1,0, 0xFFFFFFFF,0x9A, 0xCF); // kernel code segment
  setGdtGate(2,0, 0xFFFFFFFF,0x92, 0xCF); // kernel data segment
  setGdtGate(3,0, 0xFFFFFFFF,0xFA, 0xCF); // user code segment
  setGdtGate(4,0, 0xFFFFFFFF,0xF2, 0xCF); // user data segment

  // 0x9A = 1001 1010
  // this sets out the right values for our kernel code segment's important stuff
  // and is repeated for all other segments
  // e.g. Present bit = 1 (one bit)
  //      Descriptor privelige level = 0 (two bits)
  // etc.

  gdt_flush((uint32_t)&gdt_ptr);
}


void setGdtGate(uint32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
  // this takes the segment number, whether or not the segment grows up or down (the base), its limit, its access and the granulation

  gdt_entries[num].base_low = (base & 0xFFFF);
  gdt_entries[num].base_middle = (base >> 16) & 0xFF;
  gdt_entries[num].base_high = (base >> 24) & 0xFF;

  gdt_entries[num].limit = (limit & 0xFFFF);
  gdt_entries[num].flags = (limit >> 16 ) & 0x0F;
  gdt_entries[num].flags |= (gran & 0xF0);

  gdt_entries[num].access = access;
}
