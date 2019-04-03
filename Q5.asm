org 0x7c00
jmp 0x0000:main
data:
    basq db 'Basquete', 0
    fut db 'futebol', 0
    art db 'artes marciais', 0
    vol db 'volei', 0
    rug db 'rugby', 0
    pai1 db '---',0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    pai2 db '---',0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    pai3 db '---',0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    string times 4 db 0
    news times 15 db 0
    tem1 db '0'
    tem2 db '0'
putchar:
  mov ah, 0x0e
  int 10h
  ret
getchar:
  mov ah, 0x00
  int 16h
  ret
delchar:
  mov al, 0x08         
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08         
  call putchar
  ret
endl:
  mov al, 0x0a         
  call putchar
  mov al, 0x0d         
  call putchar
  ret
prints:             
  .loop:
    lodsb           
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
gets:                 
  xor cx, cx          
  .loop1:
    call getchar
    cmp al, 0x08      
    je .backspace
    cmp al, 0x0d     
    je .done
    cmp cl, 3
    je .loop1
    stosb
    inc cl
    call putchar
    jmp .loop1
    .backspace:
      cmp cl, 0
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

strcpy:
  .loop1:
    lodsb
    stosb
    cmp al, 0
    je .endloop1
    jmp .loop1
  .endloop1:
  ret

main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    ini:
        mov si, pai3
        call prints
        mov al,'|'
        call putchar
        mov si, pai1
        call prints
        mov al,'|'
        call putchar
        mov si, pai2
        call prints
        call endl
        mov di, string 
        call gets
        mov si, string
        lodsb
        mov di, news
        cmp al, 'b'
        jne next
            mov si, basq
            call strcpy
            jmp next5
        next:
        cmp al, 'v'
        jne next2
            mov si, vol
            call strcpy
            jmp next5
        next2:
        cmp al, 'r'
        jne next3
            mov si, rug
            call strcpy
            jmp next5
        next3:
        cmp al, 'a'
        jne next4
            mov si, art
            call strcpy
            jmp next5
        next4:
        cmp al, 'f'
        jne next5
            mov si, fut
            call strcpy
        next5:
        mov si, string
        lodsb
        lodsb
        lodsb
        mov si, news
        cmp al, '3'
        jne cont
            mov di, pai3
            call strcpy
        jmp ini
        cont:
        ;;COMPARANDO 2
        cmp al, '2'
        jne cont2
        mov si, tem2
        lodsb
        cmp al,'0'
        je al2b
            mov si, pai2
            mov di, pai3
            call strcpy
        al2b:
        mov si, news
        mov di, pai2
        call strcpy
        mov di,tem2
        mov byte[di], '1'
        jmp ini
        ;;COMPARANDO 1
        cont2:
        mov si, tem1
        lodsb
        cmp al,'0'
        je al1b
            mov si, tem2
            lodsb
            cmp al,'0'
            je al12b
                mov si, pai2
                mov di, pai3
                call strcpy
            al12b:
            mov si, pai1
            mov di, pai2
            call strcpy
            mov di,tem2
            mov byte[di], '1'

        al1b:
        mov si, news
        mov di, pai1
        call strcpy
        mov di,tem1
        mov byte[di], '1'
        jmp ini
    
times 510-($-$$) db 0
dw 0xaa55
