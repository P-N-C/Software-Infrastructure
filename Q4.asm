org 0x7c00
jmp 0x0000:main
 
data:
  string times 25 db 0
 
; calls
putchar:
  mov ah, 0x0e
  int 10h
  ret
 
getchar:
  mov ah, 0x00
  int 16h
  ret
 
delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret
 
endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret
 
prints:             ; mov si, string
  xor cx, cx
    aloop:
        lodsb           ; bota character em al
        cmp al, 0
        je aendloop
        cmp al, ' '
        je cont
        cmp cl, 0
        je maiu
        jmp minu
   
    cont:
        call putchar
        jmp aloop
    maiu:
        inc cl
        cmp al, 'Z'
        jle cont
        sub al, 32
        jmp cont
    minu:
        dec cl
        cmp al, 'Z'
        jg cont
        adc al, 31
        jmp cont
    aendloop:
        ret
 
gets:                 ; mov di, string
  mov cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 24        ; string limit checker
    je .loop1
   
    stosb
    inc cl
    call putchar
   
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret
 
 
main:
  xor ax, ax
  mov ds, ax
  mov es, ax
  call gets
  call prints
 
times 510-($-$$) db 0
dw 0xaa55
