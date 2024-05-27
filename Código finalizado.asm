section .text

    global _start               
    
;main
    _start:                             

        push ebp                        ; salva o registrador base na pilha
        mov ebp, esp                    ; ebp recebe o ponteiro para o topo da pilha

        ; Mensagem inicial
        mov edx,len                     ; recebe o tamanho da mensagem
        mov ecx,menu                    ; recebe a mensagem
        mov ebx,1                       ; stdin
        mov eax,4                       ; systemcall sys.write
        int 0x80                        ; Executa interrupção

        ;Recebe entrada
        mov edx, 5                      ; tamanho da entrada 
        mov ecx, disk                   ; armazenamento em 'disk'
        mov ebx, 0                      ; entrada padrão
        mov eax, 3                      ; informa que serÃ¡ uma leitura           
        int 0x80                        ; Executa interrupção
        
        mov edx, disk                   ; eax recebe quantidade de disco
        call    _atoi

        ; Empilha as 3 torres
        push dword 0x2                  ; torre auxiliar 
        push dword 0x3                  ; torre de destino 
        push dword 0x1                  ; torre de origem 
        push eax                        ; numero de discos

        call Hanoi                      ; Chama a função Hanoi

        ; Finaliza
        mov eax, 1                      ; Saida do sistema
        mov ebx, 0                      ; saida padrão  
        int 0x80                        ; Executa interrupção


; Converte para inteiro

_atoi:
    xor     eax, eax                    ; Limpa o registrador 
    mov     ebx, 10                     ; EBX vai guardar o valor a ser multiplicado
    
    .loop:
        movzx   ecx, byte [edx]         ; Move um byte de EDX para ECX
        inc     edx                     ; Incrementa ponteiro edx
        cmp     ecx, '0'                ; Compara ECX com '0'
        jb      .done                   ; Se menor, pula pra linha .done
        cmp     ecx, '9'                ; Compara ECX com '9'
        ja      .done                   ; Se maior, pule pra linha .done
        sub     ecx, '0'                ; Transforma em inteiro(subtração em binário)
        imul    eax, ebx                ; Usa o valor de ebx para multiplicar eax
        add     eax, ecx                ; Adiciona o valor de ECX a EAX
        jmp     .loop                   ; Pula para começo do loop, que continua até condição ser cumprida
    
    .done:
        ret 


;Função recursiva de Hanoi

    Hanoi: 


        ; Prólogo
        push ebp                        
        mov ebp,esp                     

        mov eax,[ebp+8]                 ; pega o a posição do primeiro elemento da pilha e mov para eax
        cmp eax,0x0                     ; compara com 0(em hexdec)
        jle fim                         ; Se <= 0, finaliza
        
        ;Recurssão inicial(n-1 para torre de auxilio)
        dec eax                         ; decrementa numero de discos a ser movido nesta etapa em 1
        push dword [ebp+16]             
        push dword [ebp+20]             
        push dword [ebp+12]             
        push dword eax                  ; poe eax = n-1  para iniciar recursividade
        call Hanoi                      ; Chamada recursiva

        ;Movimento do maior disco para a torre destino
        add esp,12                      
        push dword [ebp+16]            
        push dword [ebp+12]             
        push dword [ebp+8]              
        call print                      ; Chama a função 'print'
        
        ;Recurssão final(n-1 da auxilio para final)
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+12]             
        push dword [ebp+16]             
        push dword [ebp+20]             
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa numero de discos a ser movido nesta etapa em 1

    push dword eax                      ; poe eax na pilha
        call Hanoi                      ; (recursividade)

    fim: 
        
        mov esp,ebp                     ; Move o valor de ebp para esp (guarda em outro registrador)
        pop ebp                         ; Remove da pilha (desempilha) o ebp
        ret                             ; Retorna a função de origem (antes de ter chamado a função 'fim')

    print:
        ; Prólogo
        push ebp                        
        mov ebp, esp                    
        mov eax, [ebp + 12]             ; Torre auxiliar
        add al, '0'                     ; converte para ASCII
        mov [torre_origem], al          ; movimento: movendo o conteudo de al para [torre_origem]

        mov eax, [ebp + 16]             ; torre de destino
        add al, '0'                     ; converte para ASCII
        mov [torre_destino], al         ; movimento: movendo o conteudo de al para [torre_destino]

        mov edx, lenght                 ; tamanho da mensagem formatada
        mov ecx, msg                    ; mensagem formatada
        mov ebx, 1                      ; dá permissão para a saida
        mov eax, 4                      ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção para kernel do linux


        ;Epílogo
        mov     esp, ebp                
        pop     ebp                     
        ret                             


;Declara constantes
section .data
   
    menu db 'Digite o número de discos: ' ,0xa          ; mensagem inicial
    len equ $-menu                                      ; tamanho da mensagem inicial


    msg:

                          db        "Torre de partida: "                      
        torre_origem:      db        " "  
                          db        " --- Torre de Destino: "     
        torre_destino:     db        " ", 0xa  
        lenght            equ       $-msg


;Declara variáveis
section .bss

    disk resb 5                 ; Armazenará número de discos digitados
