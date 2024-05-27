section .bss
    num_discos resb 2          ; espaço para armazenar o número de discos (máximo dois dígitos)
    buffer resb 16            ; buffer para armazenamento temporário

section .data
    msg_entrada db "Digite o numero de discos (maximo 2 digitos):", 0
    msg_saida db "Algoritmo da Torre de Hanoi com ", 0
    msg_mov db "Mova disco ", 0
    msg_de db " da Torre ", 0
    msg_para db " para a Torre ", 0
    msg_pulalinha db 10, 0
    msg_final db "Concluido!", 0

section .text
    extern GetStdHandle, ReadConsoleA, WriteConsoleA, ExitProcess
    extern lstrlenA
    global _start

section .idata
    dd 0, 0, 0, 0, 0
    dd 0, 0, 0, 0, 0
    dd 0, 0, 0, 0, 0
    dd 0, 0, 0, 0, 0
    dd 0, 0, 0, 0, 0

_start:
    ; obter os handles para entrada e saída padrão
    push -11                 ; STD_INPUT_HANDLE
    call GetStdHandle
    mov [stdin_handle], eax

    push -11                 ; STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [stdout_handle], eax

    ; solicitar entrada do usuário
    push msg_entrada
    call lstrlenA
    mov edx, eax             ; comprimento da string
    mov ecx, msg_entrada
    mov ebx, [stdout_handle]
    call print_string

    ; ler entrada do usuário
    mov ecx, num_discos
    mov edx, 2
    call read_input

    ; converter entrada de string para número
    movzx eax, byte [num_discos]
    sub eax, '0'
    movzx ebx, byte [num_discos + 1]
    cmp ebx, 10
    je .skip_second_digit     ; se o segundo dígito for nulo, pular
    sub ebx, '0'
    imul eax, 10
    add eax, ebx
.skip_second_digit:
    mov [num_discos], eax      ; armazenar número de discos em num_discs

    ; exibir mensagem de início
    push msg_saida
    call lstrlenA
    mov edx, eax
    mov ecx, msg_saida
    mov ebx, [stdout_handle]
    call print_string

    ; converter número de discos para string e exibir
    mov eax, [num_discos]
    call int_to_str
    mov edx, 1                ; um dígito
    mov ecx, buffer
    mov ebx, [stdout_handle]
    call print_string

    ; exibir nova linha
    mov edx, 1
    mov ecx, msg_pulalinha
    mov ebx, [stdout_handle]
    call print_string

    ; chamada recursiva para resolver a Torre de Hanoi
    mov eax, [num_discos]
    push eax
    push 'C'
    push 'B'
    push 'A'
    call hanoi

    ; exibir mensagem de conclusão
    push msg_final
    call lstrlenA
    mov edx, eax
    mov ecx, msg_final
    mov ebx, [stdout_handle]
    call print_string

    ; sair do programa
    push 0                   ; código de saída 0
    call ExitProcess

; Procedimento recursivo para resolver a Torre de Hanoi
hanoi:
    push ebp
    mov ebp, esp
    sub esp, 4                ; espaço para variável local

    mov eax, [ebp + 20]       ; número de discos
    cmp eax, 1
    je .mover_disco

    ; chamada recursiva para mover (n-1) discos de origem para auxiliar
    dec eax
    push eax
    push dword [ebp + 16]     ; destino
    push dword [ebp + 12]     ; auxiliar
    push dword [ebp + 8]      ; origem
    call hanoi

    ; mover o disco restante de origem para destino
    inc eax
.mover_disco:
    push eax
    push dword [ebp + 16]
    push dword [ebp + 8]
    call move
    add esp, 12               ; limpar a pilha

    ; chamada recursiva para mover (n-1) discos de auxiliar para destino
    dec eax
    push eax
    push dword [ebp + 16]     ; destino
    push dword [ebp + 8]      ; origem
    push dword [ebp + 12]     ; auxiliar
    call hanoi

    add esp, 4                ; limpar a pilha
    mov esp, ebp
    pop ebp
    ret

; Procedimento para imprimir o movimento de um disco
move:
    push ebp
    mov ebp, esp

    push msg_mov
    call lstrlenA
    mov edx, eax
    mov ecx, msg_mov
    mov ebx, [stdout_handle]
    call print_string

    ; converter número do disco para string e imprimir
    mov eax, [ebp + 8]
    call int_to_str
    mov edx, 1                ; um dígito
    mov ecx, buffer
    mov ebx, [stdout_handle]
    call print_string

    ; imprimir " da Torre "
    push msg_de
    call lstrlenA
    mov edx, eax
    mov ecx, msg_de
    mov ebx, [stdout_handle]
    call print_string

    ; imprimir torre de origem
    mov edx, 1
    mov ecx, [ebp + 12]
    mov ebx, [stdout_handle]
    call print_string

    ; imprimir " para a Torre "
    push msg_para
    call lstrlenA
    mov edx, eax
    mov ecx, msg_para
    mov ebx, [stdout_handle]
    call print_string

    ; imprimir torre de destino
    mov edx, 1
    mov ecx, [ebp + 16]
    mov ebx, [stdout_handle]
    call print_string

    ; imprimir nova linha
    mov edx, 1
    mov ecx, msg_pulalinha
    mov ebx, [stdout_handle]
    call print_string

    mov esp, ebp
    pop ebp
    ret

; Função para converter inteiro para string
int_to_str:
    mov ebx, buffer
    add eax, '0'
    mov [ebx], al
    mov byte [ebx + 1], 0
    ret

; Função para imprimir strings
print_string:
    push eax
    push ecx
    push edx
    push ebx

    mov eax, [esp + 20]       ; handle
    mov ebx, eax
    mov eax, [esp + 20 + 4]   ; buffer
    mov ecx, eax
    mov eax, [esp + 20 + 8]   ; length
    mov edx, eax
    push 0                    ; lpNumberOfCharsWritten (NULL)
    push edx                  ; nNumberOfCharsToWrite
    push ecx                  ; lpBuffer
    push ebx                  ; hConsoleOutput
    call WriteConsoleA

    pop ebx
    pop edx
    pop ecx
    pop eax
    ret

; Função para ler entrada
read_input:
    push eax
    push ecx
    push edx
    push ebx

    mov eax, [stdin_handle]   ; handle
    mov ebx, eax
    mov eax, [esp + 20 + 4]   ; buffer
    mov ecx, eax
    mov eax, [esp + 20 + 8]   ; length
    mov edx, eax
    push 0                    ; lpNumberOfCharsRead (NULL)
    push edx                  ; nNumberOfCharsToRead
    push ecx                  ; lpBuffer
    push ebx                  ; hConsoleInput
    call ReadConsoleA

    pop ebx
    pop edx
    pop ecx
    pop eax
    ret

section .data
    stdin_handle dd 0
    stdout_handle dd 0
