org 0x7c00
jmp 0x0000:Start
 
ask db 'Calcule seu triangulo regular: ' , 0 ; acima de 361 da overflow
result db 'Resultado : ' , 0
string times 101 db 0
Start:
    mov si , ask
    call print ; printar a frase inicial
    xor ax, ax ; inicializa os registradores
    mov ds, ax
    mov es, ax
    mov bx , 0
    mov cx , 0
    mov bl , 0
    mov di, string
    call gets ; chama funcao para pegar o numero
    jmp PA ; vai para funcao que calcula a PA
   
 
   
 
    ;ax = divisao
    ;bx = numero da soma
    ;cx = contador para saber quantidade de digitos
    ;dx = resto da divisao
 
;funcoes da monitoria    
getchar:
      mov ah, 0
      int 16h
      ret
char_to_int:
      sub al, 48 ;char para int
      ret
_putchar:
      mov ah, 0x0e
      int 10h
      ret
_newline:
    mov al , 10
    call _putchar
    mov al , 13
    call _putchar
    jmp PA
 
del_char:
      mov al, 0x08
      call _putchar
      mov al, ''
      call _putchar
      mov al, 0x08
      call _putchar
      ret
 
endl:
  mov al, 0x0a          ; line feed
  call _putchar
  mov al, 0x0d          ; carriage return
  call _putchar
  ret
reverse:                        ; mov si, string
    mov di, si
    xor cx, cx                  ; zerar contador
    .loop1:                     ; botar string na stack
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1
    .endloop1:
    .loop2:                     ; remover string da stack              
        pop ax
        stosb
        loop .loop2
    ret
 
tostring:                       ; mov ax, int / mov di, string
    push di
    .loop1:
        cmp ax, 0
        je .endloop1
        xor dx, dx
        mov bx, 10
        div bx                  ; ax = 9999 -> ax = 999, dx = 9
        xchg ax, dx             ; swap ax, dx
        add ax, 48              ; 9 + '0' = '9'
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
 
stoi:                           ; mov si, string
    xor cx, cx
    xor ax, ax
    .loop1:
        push ax
        lodsb
        mov cl, al
        pop ax
        cmp cl, 0               ; check EOF(NULL)
        je .endloop1
        sub cl, 48              ; '9'-'0' = 9
        mov bx, 10
        mul bx                  ; 999*10 = 9990
        add ax, cx              ; 9990+9 = 9999
        jmp .loop1
    .endloop1:
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
    call _putchar
   
    jmp .loop1
    .backspace:
      cmp cl, 0      ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call del_char
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret
 
print:                          ; mov si, string
    .loop:
        lodsb                   ; bota character em al
        cmp al, 0
        je .endloop
        call _putchar
        jmp .loop
    .endloop:
    ret
 
PA:; calculo da PA
 
    mov si, string ; salva a string no reg
   
   
    call stoi ; converte para inteiro e salva em ax
   
   
   
   
    mov bx , 0 ; zera bx
   
    .loop1:
       
        add bx , ax ; vai somando , bx = ax + bx
       
        dec ax ; e decrementando
        ; n + n-1 + n-2 + ... + 1 + 0
 
        cmp ax , 0 ; compara com 0
        jne .loop1 ; se for maior vai pro loop
        je .endloop1;se nao , vai pra funcao de printar a resposta
    .endloop1:
    jmp resposta
 
 
 
 
 
resposta: ; funcao q comeca o processo de printar a resposta
    mov si , result
    call print ; printar a frase de resultado
    mov di , string
    mov ax , bx ; move o resultado da soma para ax
    call tostring ; converte ax para string
    mov si , string
    call print; printa o resultado
    call endl;pula linha
    jmp end
   
 
end:;encerra programa
   
 
   
      mov ah, 4CH
      int 21h
      jmp $
times 510 - ($ - $$) db 0
dw 0xaa55
