%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward); \\ No registers
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE
    ; PRINTF32 `%d\n\x0`, eax
    mov edi, ecx
    mov esi, eax

    cmp edx, 0
    jnz forward

    mov edx, 26
    sub edx, eax
    mov eax, edx
    mov esi, eax
    
forward:
    
    mov eax, ebx
    mov ebx, 52
    mul ebx
    xor ebx, ebx
    mov bx, ax

    add ebx, 26

    cmp esi, 0
    jz end_rot
shift_x_times:

    sub ebx, 26

    mov al, byte[edi + ebx  + 25]
    mov dl, byte[edi + ebx + 25 + 26]
    
    mov ecx, ebx
    add ecx, 26

shift_ones:
    push ecx

    mov cl, byte[edi + ebx]
    mov byte[edi + ebx], al
    mov al, cl

    mov cl, byte[edi + ebx + 26]
    mov byte[edi + ebx + 26], dl
    mov dl, cl

    pop ecx
    
    add ebx, 1
    cmp ebx, ecx
    jl shift_ones
    ; loop 1 ends

    sub esi, 1
    cmp esi, 0
    jg shift_x_times

end_rot:
    ;loop 2 ends

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
;; END ROTATE_X_POSITION

;int inc_lett(int let) \\ eax
inc_lett:
    push ebp
    mov ebp, esp
    
    push eax

    mov eax, [ebp + 8] ; let
    add eax, 1 ; let + 1
    cmp eax, 65 + 26
    jl not_over

    sub eax, 26

not_over:

    leave
    ret
;; END INC_LETT

; int inv_position(char **string, int pos) \\ eax
inv_position:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    push ecx

    mov edi, [ebp + 8] ; string
    mov esi, [ebp + 12]; pos

    add esi, 26
    mov bl, byte[edi + esi]

    mov cl, byte[edi + esi - 26]
    ; PRINTF32 `(%c)\x0`, ecx

    mov esi, 0
    xor ecx, ecx
    ; PRINTF32 `%d\n\x0`, esi
parse_string2:
    mov cl, byte[edi + esi]

    cmp bl, cl
    jz found2

    add esi, 1
    cmp esi, 26
    jl parse_string2

found2:
    ; PRINTF32 `%d\n\x0`, esi
    mov eax, esi
    pop ecx
    pop ebx
    pop esi
    pop edi
    leave
    ret
;; END NEXT_POSITION

; int next_position(char **string, int pos) \\ eax
next_position:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    push ecx

    mov edi, [ebp + 8] ; string
    mov esi, [ebp + 12]; pos

    mov bl, byte[edi + esi]
    
    ; PRINTF32 `(%c)\x0`, ebx

    mov esi, 26
    xor ecx, ecx
parse_string:
    mov cl, byte[edi + esi]

    cmp bl, cl
    jz found

    add esi, 1
    cmp esi, 52
    jl parse_string

found:
    sub esi, 26
    ; PRINTF32 `%d\n\x0`, esi
    mov eax, esi
    pop ecx
    pop ebx
    pop esi
    pop edi
    leave
    ret
;; END NEXT_POSITION

; void print_rotors(char **mat) \\ No registers
print_rotors:
    push ebp
    mov ebp, esp
    pusha

    mov edx, [ebp + 8]

    xor ebx, ebx
loop3:

    xor ecx, ecx
loop4:
    push ecx
    add ecx, ebx
    PRINTF32 `%c \x0`, byte[edx + ecx]
    pop ecx

    add ecx, 1
    cmp ecx, 26
    jl loop4

    PRINTF32 `\n\x0`

    add ebx, 26
    cmp ebx, 260
    jl loop3

    popa
    leave
    ret    
;; END PRINT_ROTORS

; void move_rotors(char **rotors, char key[3], char notches[3]);
move_rotors:
    push ebp
    mov ebp, esp
    pusha

    mov edi, [ebp + 8] ; rotors
    mov esi, [ebp + 12] ; key
    mov edx, [ebp + 16] ; notches

    mov al, byte[esi + 2]
    ; Rot right / 3
    push 0
    push edi
    push 2
    push 1
    
    call rotate_x_positions
    add esp, 16

    mov al, byte[esi + 1]
    mov bl, byte[edx + 1]
    ; PRINTF32 `%c %c\n\x0`, eax, ebx
    cmp al, bl
    jz rot_mid 

    mov al, byte[esi + 2]
    mov bl, byte[edx + 2]
    ; PRINTF32 `%c %c\n\x0`, eax, ebx
    cmp al, bl
    jnz increment3
    
rot_mid:
    push 0
    push edi
    push 1
    push 1
    call rotate_x_positions
    add esp, 16

    mov al, byte[esi + 1]
    mov bl, byte[edx + 1]
    ; PRINTF32 `%c %c\n\x0`, eax, ebx
    cmp al, bl
    jnz increment2

    ; Rot left / 1
    push 0
    push edi
    push 0
    push 1
    call rotate_x_positions
    add esp, 16

    ; Inc left
    mov al, byte[esi]
    
    push eax
    call inc_lett
    add esp, 4
    mov byte[esi], al

    ; Inc mid
increment2:
    mov al, byte[esi + 1]
    
    push eax
    call inc_lett
    add esp, 4
    mov byte[esi + 1], al

    ; Inc right
increment3:
    mov al, byte[esi + 2]
    
    push eax
    call inc_lett
    add esp, 4
    mov byte[esi + 2], al
    ; PRINTF32 `\n\x0`
    popa
    leave
    ret
;; END MOVE_ROTORS

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE

    push eax
    
    mov al, byte[ecx]
    push eax
    call inc_lett
    add esp, 4

    pop eax

    pusha

    mov esi, ebx 
    mov ecx, 0
print:
    mov al, byte[esi + ecx]  

    add ecx, 1
    cmp ecx, 3
    jnz print

    popa
    
    mov esi, eax
    xor eax, eax
    mov al, byte[esi]

    ; ROT MAT
    push ecx
    push ebx
    push edx
    call move_rotors
    add esp, 12
    ; ROT MAT
    
while_len:

    ; PLUGBOARD POSITION
    push eax
    push ecx
    push edx
    
    xor ecx, ecx
    mov cl, al
    
    sub cl, 65
    add edx, 208
    
    push ecx
    push edx
    call inv_position
    add esp, 8

    mov cl, al
    add cl, 65

    sub cl, 65


    ; ROTOR 3

    sub edx, 104
    
    push ecx
    push edx
    call inv_position
    add esp, 8
    
    mov cl, al
    add cl, 65
    
    sub cl, 65
    ; ROTOR 2

    sub edx, 52
    
    push ecx
    push edx
    call inv_position
    add esp, 8
    
    mov cl, al
    add cl, 65
    
    sub cl, 65
    ; ROTOR 1

    sub edx, 52

    push ecx
    push edx
    call inv_position
    add esp, 8

    mov cl, al
    ; REFLECTOR
    add cl, 65
    
    sub cl, 65
    add edx, 156 
    
    push ecx
    push edx
    call inv_position
    add esp, 8

    mov cl, al
    add cl, 65
    
    sub cl, 65

    ; ROTOR 1
    sub edx, 156
    
    push ecx
    push edx
    call next_position
    add esp, 8
   
    mov cl, al
    add cl, 65
    
    sub cl, 65
    ; ROTOR 2
    add edx, 52
    
    push ecx
    push edx
    call next_position
    add esp, 8

    mov cl, al
    add cl, 65
    
    sub cl, 65
    ; ROTOR 3
    add edx, 52

    push ecx
    push edx
    call next_position
    add esp, 8

    mov cl, al
    add cl, 65
    
    sub cl, 65
    ; PLUGBOARD
    add edx, 104

    push ecx
    push edx
    call next_position
    add esp, 8

    mov cl, al
    add cl, 65
    
    mov byte[edi], cl
    add edi, 1

    pop edx
    pop ecx
    pop eax
    
    ; ROT MAT
    push ecx
    push ebx
    push edx
    call move_rotors
    add esp, 12
    ; ROT MAT

    mov byte[esi], 0
    add esi, 1
    mov al, byte[esi]
    test al , al
    jnz while_len
    ; PRINTF32 `\n\x0`
    mov byte[edi], al

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY