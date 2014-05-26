    org 07c00h          ; 告诉编译器程序加载到7c00处
    mov ax, cs
    mov ss, ax
    mov ax, 0A000h
    mov ds, ax
    mov es, ax
    xor ax, ax
    mov sp, Stack
    call SetModeGraphic
    mov ax, 100
    mov dl, 100
    mov dh, 100
    mov cx, 50
    call drawSquare
    mov ax, 50
    mov dl, 50
    mov dh, 50
    mov cx, 100
    call drawVerticalLine
    mov ax, 10
    mov dl, 10
    mov dh, 30
    mov cx, 100
    call drawHorizontalLine
    mov ax, 180
    mov dl, 30
    mov dh, 41
    mov cx, 25
    call drawTriangle
    mov ax, 180
    mov dl, 30
    mov dh, 80
    mov cx, 25
    call drawCircle

    jmp $

drawCircle:
    push ax
    push bx
    push cx
    push dx
    call drawUpperCircle
    call drawLowerCircle
    pop dx
    pop cx
    pop bx
    pop ax
    ret



; ax: center x 
; dl: center y
; dh: color
; cl: radius
drawUpperCircle:
    push ax
    push bx
    push cx
    push dx
    mov bl, dl
    sub dl, cl
    mov cx, 0
drawUpperCircleBegin:
    call drawHorizontalLine
    inc dl
    add cx, 2
    sub ax, 1
    cmp bl, dl
    jnz drawUpperCircleBegin
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    

; ax: center x 
; dl: center y
; dh: color
; cl: radius
drawLowerCircle:
    push ax
    push bx
    push cx
    push dx
    mov bl, dl
    add bl, cl
    add dl, cl
    add ax, cx
drawLowerCircleBegin:
    call drawHorizontalLine
    inc dl
    sub cx, 2
    add ax, 1
    cmp bl, dl
    jnz drawLowerCircleBegin
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    

; ax: bottom edge center x 
; dl: bottom edge center y
; dh: color
; cl: edge length / 2
drawTriangle:
    push ax
    push bx
    push cx
    push dx
    mov bl, dl
    sub dl, cl
    mov cx, 0
drawTriangleBegin:
    call drawHorizontalLine
    inc dl
    add cx, 2
    sub ax, 1
    cmp bl, dl
    jnz drawTriangleBegin
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; cx: edge length
; ax: x
; dl: y
; dh: color
drawSquare:
    push bx
    push dx
    mov bx, cx
drawSquareBegin:
    dec bx
    cmp bx, 0
    jz drawSquareDone
    call drawHorizontalLine
    inc dl
    jmp drawSquareBegin
drawSquareDone:
    pop dx
    pop bx
    ret

    
; cx: length
; dl: y
; ax: x
; bh: color
drawVerticalLine:
    push ax ; [sp+4]
    push dx ; [sp-2]
    push cx
    push bx
    xor bx, bx
setX:
    add bx, 320
    dec dl
    cmp dl, 0
    jnz setX
    add bx, ax
    mov di, bx
    xor ax, ax
    mov al, dh
    cld
drawVerticalLineNextPoint:
    stosb
    add bx, 320
    mov di, bx
    dec cx
    cmp cx, 0
    jnz drawVerticalLineNextPoint
    pop bx
    pop cx
    pop dx
    pop ax
    ret

; cx: length
; dl: y
; ax: x
; bh: color
drawHorizontalLine:
    push ax ; [sp+4]
    push dx ; [sp-2]
    push cx
    push bx
    xor bx, bx
drawHorizontalLineSetX:
    add bx, 320
    dec dl
    cmp dl, 0
    jnz drawHorizontalLineSetX
    add bx, ax
    mov di, bx
    xor ax, ax
    mov al, dh
    cld
    rep stosb
    pop bx
    pop cx
    pop dx
    pop ax
    ret

SetModeGraphic:
    mov ah, 0
    mov al, 13h
    int 10h
    ret

    
times   510-($-$$)  db  0   ; 填充剩下的空间，使生成的二进制代码恰好为512字节
Stack:
dw  0xaa55              ; 结束标志

     
