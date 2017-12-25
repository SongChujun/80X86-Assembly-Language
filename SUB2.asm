.386
code segment use16
assume cs:code,ss:stack
start:
mov ah,35h
mov al,19h
int 21h
mov cx,bx
mov dx,es
mov ah,4ch
int 21h
code ends

stack segment use16 stack
db 200 dup(200)
stack ends
end start