OS With custom bootloader, Video memory editor, GDT, DiskReader & Print & CPUID Functions.

Things to add: live memory editor from user input
ex: 
mov al,0x01
int 0x21
mov dl,al ;move the integer entered by the user, into dl


HOW TO COMPILE AND BOOT:

requirments: nasm, Bochs

in a console type:

nasm bootloader.asm -f bin -o bootloader.bin

nasm ExtendedProgram.asm -f bin -o ExtendedProgram.bin

copy /b bootloader.bin+ExtendedProgram.bin bootloader.flp

Then, open Boch ![Boch1](https://cdn.discordapp.com/attachments/762135401410068513/808582853964857354/Screenshot_1.png)
Click "Edit"
![Boch2](https://cdn.discordapp.com/attachments/762135401410068513/808584415344853012/download.png)

Done! 

Enjoy.
