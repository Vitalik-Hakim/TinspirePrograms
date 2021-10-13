; hello_world.asm
;
; Author: Vitalik Hakim
; Date: 13-oct-2021
global _start

section .text:

_start:
   mov eax, 0x4          ;use the write syscall
   mov ebx, 1            ; use the stdout as the fd
   mov ecx, message      ; use the message as the buffer
   mov edx, message_length ; and supply the length
   int 0x80               ; invoke the syscall  
    
    ; Now exit

   
