.386
code segment use16
assume cs:code,ss:stack
start:
xor ax,ax
mov ds,ax
mov ax,ds:[19h*4]
mov bx,ds:[19h*4+2]
mov ah,4ch
int 21h
code ends

stack segment use16 stack
db 200 dup(200)
stack ends
end start