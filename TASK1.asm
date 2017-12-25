.386
stack segment use16 stack
    db 64 dup(?)
stack ends

data segment use16
Msg db 'Hello, World!', 0dh, 0ah, '$'
data ends

code segment use16
    assume cs: code, ds: data, ss: stack
start:mov ax, data
      mov ds, ax
      MOV AH,-0101011B
      MOV AL,-1011101B
      ADD AH,AL
    
      mov ah, 4ch
      int 21h
code ends
end start
