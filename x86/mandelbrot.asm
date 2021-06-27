WIDTH       equ   4
HEIGHT      equ   2
RESOLUTION  equ   512
MAX_ITERS   equ   1000

SYS_WRITE equ 4
SYS_EXIT  equ 1
SYS_BRK   equ 45

STDOUT    equ 1

section .text
  global _start

_start:
; arr_size to string
;  mov eax, arr_size
  mov eax, 1
  mov esi, buffer
  call int_to_string

  ;mov edx, ecx
  ;mov ecx, [eax]
  ;call print

  mov [buffer], '1'

  mov edx, 1
  mov ecx, buffer
  call print

  call exit

;compute width and heigth
  mov eax, WIDTH
  add eax, RESOLUTION
  mov [width], eax

  mov eax, HEIGHT
  add eax, RESOLUTION
  mov [height], eax

  mov eax, SYS_BRK
  xor ebx, ebx
  int 0x80

;compute iterations table size
  mov eax, [width]
  mov ebx, [height]
  mul ebx
  mov ebx, 4
  mul ebx 
  mov [arr_size], eax

;allocate iterations table
  add eax, ecx 
  mov ebx, eax
  mov eax, SYS_BRK
  int 0x80

; arr_size to string
;  mov eax, arr_size
  mov eax, 1
  mov esi, buffer
  call int_to_string

  mov edx, ecx
  mov ecx, buffer
  call print




exit:
  mov eax, SYS_EXIT
  int 0x80



print:
  mov ebx, STDOUT 
  mov eax, SYS_WRITE
  int 0x80
  ret

; Input:
; eax = integer value to convert
; esi = pointer to buffer to store the string in (must have room for at least 10 bytes)
; Output:
; eax = pointer to the first character of the generated string
; ecx = length of the generated string
int_to_string:
  add esi,9
  mov byte [esi],0    ; String terminator

  mov ebx,10
.next_digit:
  xor edx,edx         ; Clear edx prior to dividing edx:eax by ebx
  div ebx             ; eax /= 10
  add dl,'0'          ; Convert the remainder to ASCII 
  dec esi             ; store characters in reverse order
  mov [esi],dl
  test eax,eax            
  jnz .next_digit     ; Repeat until eax==0

  ; return a pointer to the first digit (not necessarily the start of the provided buffer)
  mov eax,esi
  ret


section .data
  msg db 'Hello, world!', 0xa
  len equ $ - msg

  width: dd 0x0
  height: dd 0x0
  arr_size: dd 0x0

  int_fmt db '%d', 0xa, 0x0

section .bss
  buffer resb 10

