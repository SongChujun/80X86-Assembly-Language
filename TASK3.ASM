.386
assume cs:code
code segment
start:mov al,8
      out 70h,al
      in al,71h
      mov bl,al
      mov bh,bl
      mov cl,4
      shr bh,cl
      and bl,00001111b

      add bh,30h
      add bl,30h

      mov dl,bh
      mov ah,2
      int 21h

      mov dl,bl
      mov ah,2
      int 21h

      mov ah,4ch
      int 21h
code ends
end start