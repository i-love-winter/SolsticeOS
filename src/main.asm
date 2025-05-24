org 0x7c00
bits 16

main: 
  ; setup data segments
  mov ax, 0   ; can't write to es/ds directly, 
  mov ds, ax  ; so you must mov from another register
  mov es, ax

  ;setup stack
  mov ss, ax
  mov sp, 0x7c00 ; the stack goes downwards, and this is setting it to go downwards from the start of our program, to ensure it doesn't overwrite any code

  hlt

.halt
  jmp .halt

times 510-($-$$) db 0
dw 0AA55h
