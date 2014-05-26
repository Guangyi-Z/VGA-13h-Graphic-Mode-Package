#VGA Graphic Mode Package

##How to run it

###Build

The following is assuming you are using \*nix or OS X.

This project is written in NASM[http://www.nasm.us/].
And there is only one source file(I put them all together since I need to limit their address within the first sector, 512 bytes).

You can re-compile it.
'''sh
nasm -o main.bin main.asm
'''

Then you have to overwrite the virtual floppy with this generated binary file.
(If you would like to generate your own floppy or hard disk, I recommend you to use **bximage**)
'''sh
dd if=main.bin of=a.img bs=512 count=1 conv=notrunc
'''

Following is the final snapshot :-D

{images/res.png}

###Debug and Check through
I test it by making it as the first sector(boot sector) in my virtual floppy. Or you can also change it into a DOS com file if you like.
With **Bochs**, a famous PC simulator, you can run it smoothly without overwrite your own boot sector, which will conflict with your current operating system.

If you haven't install bochs, go here.
[http://bochs.sourceforge.net/]

After you get bochs installed, change into the root directory of this project, run the following. It will automatcally read the configration file ''bochsrc'' under the dir and start.
> If you have the debug function turned on, press ENTER again to start.
'''sh
bochs
'''

As I set the load address of this program to ''0x7c00'', if you want to run and see it step by step, you can do the following under the debug mode in bochs.
'''sh
$ b 0x7c00 

# this will stop at the first line of the program
$ c

# then you can see what is happening inside with the following two command, NEXT and STEP INTO
$ n
$ s

# you can disassembly the program, NUM is how many assembly instructions you would like to check
$ u /NUM

# check the registers
$ r
'''

Or you can also use **Qemu**(a very good one, you can debug it with gdb) or even **Virtual Box**?(I am not familiar with this one) to simulate this tiny standalone program.
But you will have to write yourself the configurations file to work it up.

##What the hell is inside

The memory mapped by VGA graphic mode begins at ''0xA000'' from which each byte is representing the color of a pixel in the screen. In total there are 320\*200 pixel.
There are 256 colors on your choice. You can see [http://en.wikipedia.org/wiki/Video_Graphics_Array|here] to check all of them.

'''asm
    mov ax, 0A000h
    mov ds, ax
    mov es, ax
'''

'''
Segment (hex)
 TOP OF    FFFF  +---------------------------+
 MEMORY          |                           | ROM BIOS
           F000  +---------------------------+
                 |                           | Cartridge ROM Area, ROM BIOS,
           E000  +---------------------------+ or EMS Window
                 |                           | Cartridge ROM Area, BIOS
           D000  +---------------------------+ Extensions, or EMS Window
                 |                           | BIOS Extensions or EMS Window
           C000  +---------------------------+
                 |                           | Video Memory (Text)
           B000  +---------------------------+
                 |                           | Video Memory (Graphics)
           A000  +---------------------------+ <--- 640K Working RAM Limit
                 |                           | Working RAM
           9000  +---------------------------+
                 |                           | Working RAM
           8000  +---------------------------+
                 |                           | Working RAM
           7000  +---------------------------+
                 |                           | Working RAM
           6000  +---------------------------+
                 |                           | Working RAM
           5000  +---------------------------+
                 |                           | Working RAM
           4000  +---------------------------+
                 |                           | Working RAM
           3000  +---------------------------+
                 |                           | Working RAM
           2000  +---------------------------+
                 |                           | Working RAM
           1000  +---------------------------+
 BOTTOM OF       |                           | Working RAM, plus system
 MEMORY    0000  +---------------------------+ information (eg. interrupt
                                               vector table)
'''

The following change the computer into 13h graphic mode, otherwise you are under the normal text mode 
'''asm
    call SetModeGraphic
'''

I write some simple shapes in different color on the screen.
''ax'' as the axis x, ''dl'' as the axis y, ''dh'' as the chose color, ''cx'' is normally the length or radius.

'''asm
    ; Square
    mov ax, 100
    mov dl, 100
    mov dh, 100
    mov cx, 50
    call drawSquare

    ; Vertical Line
    mov ax, 50
    mov dl, 50
    mov dh, 50
    mov cx, 100
    call drawVerticalLine

    ; Horizontal Line
    mov ax, 10
    mov dl, 10
    mov dh, 30
    mov cx, 100
    call drawHorizontalLine

    ; Triangle
    mov ax, 180
    mov dl, 30
    mov dh, 41
    mov cx, 25
    call drawTriangle

    ; Quarter Circle
    mov ax, 180
    mov dl, 150
    mov dh, 80
    mov cx, 25
    call drawRightQuarterCircle
'''

The most complicated one is the quarter circle, which is based on the ''drawHorizontalLine''. You have to handle and change its length dynamically.
I achieve this by ''getCircleLineLength'' function that calculate a quadratic equavilent to get the length(Though is quite simple, in assembly language it almost kills me :\() 

That is all, hope you find it useful!

##Reference

http://atrevida.comprenica.com/

