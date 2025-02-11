org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main ; need to jump to main on start, as we have written a function above it

;
; Prints a string to the screen
; Parameters:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

    push bx

.loop:
    lodsb       ; loads next character in al
    or al, al   ;verify is next charcater is null?
    jz .done

    mov ah, 0x0E    ; calls BIOS interrupt
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0   ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00  ; stack grows downwards from where we are loaded in memory

    ; print message
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello Ama!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h