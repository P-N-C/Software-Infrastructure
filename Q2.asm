org 0x7c00
jmp 0x0000:Start
variavel times 11 db 0
result times 11 db 0
ask1 db 'Digite sua base : ' , 0
ask2 db 'Digite seu expoente : ' , 0
ask3 db 'Resultado : ' , 0
 
; funçoes da monitoria
 
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
 
print:              ; mov si, string
  .loop:
    lodsb          ; bota character em al
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
 
reverse:            ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:            ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:           ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret
 
tostring:            ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx          ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx        ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
    mov al, 0
    stosb
    call reverse
    ret
 
gets:              ; mov di, string
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
   
    stosb
    inc cl
    call putchar
   
    jmp .loop1
    .backspace:
      cmp cl, 0      ; is empty?
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
 
stoi:              ; mov si, string
  xor cx, cx
  xor ax, ax
  .loop1:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0        ; check EOF(NULL)
    je .endloop1
    sub cl, 48        ; '9'-'0' = 9
    mov bx, 10
    mul bx          ; 999*10 = 9990
    add ax, cx        ; 9990+9 = 9999
    jmp .loop1
  .endloop1:
  ret
 
  Start:;main
    mov si , ask1
    call print;printa a frase para inserir a base
    xor ax, ax;inicializa
    mov ds, ax
    mov es, ax  
 
    mov di, variavel
    call gets;pega o numero
   
    mov si, variavel
    call stoi;converte para inteiro
    push ax       ; sava base na pilha
 
    mov si , ask2
    call print;printa a frase para inserir o expoente
    mov di, variavel
    call gets;pega o numero
 
    mov si, variavel
    call stoi;converte para inteiro
    cmp ax , 0;verifica se o expoente eh zero
    je vaipraum;se for zero , vai pra uma funcao q printa 1
                ; pois todo numero elevado a zero eh 1
    push ax       ; salva o expoente na pilha
 
    mov ax, 1 ; inicializa ax com 0
    pop cx        ; coloca expoente em cx
    pop bx        ; coloca base em bx
 
    .POW:
        .loop:
            mul bx ; ax = ax * bx -> ax = 1* base
            dec cx ;decrementa o expoente para multiplicar
            cmp cx , 0 ; ate expoente ser 0
            je .resposta; pula para a funcao q printa a resposta que ta em ax
            jne .loop
        .resposta:
            mov di, result
            call tostring ; converte para string
            mov si , ask3
            call print;printa a frase do resultado
            mov si, result
           
            call print ; printa a string
            call endl   ; pula linha
            jmp end
 
vaipraum:;funcao para caso o expoente seja 0
    mov ax , 1
    add ax , 48
    call putchar
    jmp end    
 
end:
        mov ah, 4CH
        int 21h
        jmp $;encerra programa
times 510-($-$$) db 0
dw 0xAA55
