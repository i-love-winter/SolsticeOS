org 0x7c00
bits 16

%define ENDL 0x0D, 0x0A

start:
  jmp main ; ensuring main is the start of the program

; implementing a simple-ish print function

putstr: ; save registers that are about to be edited
  push si
  push ax
.printloop:
  lodsb ; loading next character in al
  or al, al ; check if next charcater is null
  jz .done
  
  mov ah, 0x0e ; call bios interrupt
  int 0x10

  jmp .printloop
.done:
  pop ax
  pop si
  ret

main: 
  ; setup data segments
  mov ax, 0   ; can't write to es/ds directly, 
  mov ds, ax  ; so you must mov from another register
  mov es, ax

  ;setup stack
  mov ss, ax
  mov sp, 0x7c00 ; the stack goes downwards, and this is setting it to go downwards from the start of our program, to ensure it doesn't overwrite any code

  ; print message 
  mov si, printtext
  call putstr

  hlt
.halt:
  jmp .halt

printtext: db '########################', 10, 13, ; ten and 13 are ASCII's way of doing newlines
           db '# This OS Needs A Name #', 10, 13,
           db '########################', ENDL,  0

times 510-($-$$) db 0
dw 0AA55h
