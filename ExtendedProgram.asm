[org 0x7e00]

jmp EnterProtectedMode

%include "gdt.asm"
%include "print.asm"


EnterProtectedMode:
	call EnableA20
	cli
	; Loads gdt and bits so we can get protected mode!!! >:D
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	; Flushes cpu pipeline
	jmp codeseg:StartProtectedMode

EnableA20:
	in al, 0x92
	or al, 2
	out 0x92, al
	ret

[bits 32]

%include "SimplePaging.asm"
%include "CPUID.asm"

StartProtectedMode:

	; We need to point our new data to the GDT
	mov ax, dataseg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; mov edp, 0x90000 ; Position of our stack if needed space
	; mov esp, ebp

	; Now that we are in ProtectedMode, we have to edit the video memory of text mode to type
	mov [0xb8000], byte 'B' ; 0xb8000 is the start of video memory
	mov [0xb8002], byte 'a'
	mov [0xb8004], byte 'l'
	mov [0xb8006], byte 'l'
	mov [0xb8008], byte 's'
	mov [0xb800a], byte ' '
	mov [0xb800c], byte 'W'
	mov [0xb800e], byte 'o'
	mov [0xb8010], byte 'r'
	mov [0xb8012], byte 'l'
	mov [0xb8014], byte 'd'

	call DetectCPUID
	call DetectLongMode
	call SetUpIdentityPaging
	call EditGDT
	jmp codeseg:Start64Bit

[bits 64]

Start64Bit:
	mov edi, 0xb8000
	mov rax, 0x1f201f201f201f20
	mov ecx, 500
	rep stosq
	jmp $


; Fill memory with 2048 bytes :D
times 2048-($-$$) db 0