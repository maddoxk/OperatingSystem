; [gdt] Global Desciptor Table
; GDT has a very weird layout...
; The Global Descriptor Table (GDT) is a table in memory that defines the processor's memory segments. The GDT sets the behavior of the segment registers and helps to ensure that protected mode operates smoothly.
; The GDT comtains both Size and Offset.
; Size = Size of entry we are putting in
; Offset = Memory Address of the GDT
; In this GBT, we need a null descriptor. This is just a value in memory that is a 0. This is very important for certain functions.
; This GBT also contains a Data segment and a Code segment.

gdt_nulldesc:
	dd 0
	dd 0

	; dw 0xFFFF = THE LIMIT OF MEMORY WE ARE USING (0xFFFF is all of it)
	; dw 0x0000 = THE BASE OF MEMORY WE ARE USING (0x0000 is the very bottom)
	; db 0x00   = Base of limit
	; db 10011010b = This is the Access Byte! : 1, Valid Memory, Kernal Privledge (0-3), System segments, Executable bit (1=code 0=data), DC privledge, Read or Write bit (1=read 0=write), Access bit (we should set this to 0 and the cpu will change to 1 when its accessed), b = declared at byte
	; db 11001111b = Granularity(0=1 byte blocks, 1=4kb blocks), Size bit(0=16bit, 1=32bit),0,0, Limit (1111=biggest)
	; db 0x00 = Base base (yes, the base's base)

gdt_codedesc:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10011010b
	db 11001111b
	db 0x00
	
	; Everythings the same for the Data Descriptor, but the Access Bytes 'Executable bit' is 0 because this is data not code
gdt_datadesc:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00


gdt_end:

	; This is what we are actually passing to the cpu
gdt_descriptor:
	gdt_size:
		dw gdt_end - gdt_nulldesc - 1 
		dq gdt_nulldesc

; Codedescriptor Address
codeseg equ gdt_codedesc - gdt_nulldesc
dataseg equ gdt_datadesc - gdt_nulldesc
[bits 32]

EditGDT: ; This function edits our GDT to 64-bits. Very nice.
	mov [gdt_codedesc + 6], byte 10101111b

	mov [gdt_datadesc + 6], byte 10101111b
	ret

[bits 16]