; Project by MaddoxK
; Notes:
; db = declare bytes
; bp = base pointer of stack
; sp = stack pointer
; b register can be used as an index
; [bx] declares bx as an index
; [print.asm] the 0 is very IMPORTANT! In the function it checks if the letter = 0 then it will stop, if not, go on forever.
; 'cli' disables interupts.
; dd = double var
; hlt = halt/pause

; Tells BIOs We are in a rutine, to allow interupts.
; Move 0x0e to the upper part of the A register
; mov ah, 0x0e

; Move char to lower part of A register 
; mov al, 'Booted!'
; Tell bios to print value
; int 0x10

; create origin of memory Address
[org 0x7c00]

; Move register dl into boot_disk
mov [BOOT_DISK], dl

; Set base of the stack
; 0x7c00 = address that everything will be loaded into
mov bp, 0x7c00

; Stack pointer set to what we want everything to run on
mov sp, bp
mov bx, BootSuccessString
call PrintString

call ReadDisk

; Bootloader Jumps back to its self to run
jmp PROGRAM_SPACE

%include "print.asm"
%include "DiskRead.asm"

BootSuccessString:
	db '[Info] Boot Loader Success ',0

; Delcares what bytes we want to use
times 510-($-$$) db 0
; 0xaa55 data word that tells system this is the bootloader
dw 0xaa55

