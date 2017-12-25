.386
code segment use16
assume cs:code,ss:stack
old dw ?,?
newInt16:
pushf
call dword ptr old
;jmp old
      cmp al,61h
      jb flag  
      cmp al,7ah
      ja flag
      sub al,32
flag: iret

start:

mov ah,35h
mov al,16h
int 21h
mov word ptr cs:old,bx
mov word ptr cs:old+2,es

mov ax,0
mov es,ax

cli
mov word ptr es:[16h*4],offset newInt16
mov es:[16h*4+2],cs
sti

mov dx,offset start+15
shr dx,4
add dx,10h
mov al,0
mov ah,31h
int 21h

code ends

stack segment use16 stack
db 200 dup(200)
stack ends
end start