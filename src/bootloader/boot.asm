[org 0x7c00]
KERNEL_LOCATION equ 0x1000

; Save boot disk number
mov [BOOT_DISK], dl

; Zero out segment registers
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax

; Set up stack directly
mov sp, 0x8000

; Load kernel from disk
mov bx, KERNEL_LOCATION
mov ah, 0x02            ; BIOS read sectors
mov al, 20              ; Number of sectors to read
mov ch, 0x00            ; Cylinder
mov dh, 0x00            ; Head
mov cl, 0x02            ; Sector (starts at 1)
mov dl, [BOOT_DISK]     ; Boot disk
int 0x13                ; Read from disk

; Optional: check carry flag for disk read failure
jc disk_error

; Set video mode to 80x25 text
mov ah, 0x00
mov al, 0x03
int 0x10

; Set up GDT segment offsets
CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli                     ; Disable interrupts
lgdt [GDT_descriptor]   ; Load GDT

; Enter protected mode
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

disk_error:
jmp $                  ; Hang if disk read fails

BOOT_DISK: db 0

; ---------------- GDT ----------------
GDT_start:
    GDT_null:
        dd 0x0
        dd 0x0

    GDT_code:
        dw 0xFFFF       ; Limit
        dw 0x0000       ; Base low
        db 0x00         ; Base middle
        db 0x9A         ; Code segment descriptor
        db 0xCF         ; Granularity and limit high
        db 0x00         ; Base high

    GDT_data:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 0x92         ; Data segment descriptor
        db 0xCF
        db 0x00

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start

; ---------------- Protected Mode ----------------
[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000    ; Set up 32-bit stack

    jmp KERNEL_LOCATION ; Jump to loaded kernel

; ---------------- Boot Signature ----------------
times 510-($-$$) db 0
dw 0xAA55
