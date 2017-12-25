.386

STACK SEGMENT USE16 STACK
      DB 10 DUP(0)
STACK ENDS

DATA SEGMENT USE16

BUF_STRING DB 0AH,0DH,'Please enter the name of the student you want to query,enter q to quit! $'
T_PASSWORD DB 0AH,0DH,'Please enter password!$'
W_PASSWORD DB 0AH,0DH,'Wrong Password!Please Try again!$'
;CRLF DB 0DH,0AH,'$'


N    EQU   3
N1   EQU   N+1
P    DB 3   

OLDINT1 DW  0,0               ;1号中断的原中断矢量（用于中断矢量表反跟踪）
OLDINT3 DW  0,0               ;3号中断的原中断矢量


BUF_DATA  DB  'z' XOR 'z','h' XOR 'j','a' XOR 'h',7 DUP(0)   ;学生姓名，不足10个字节的部分用0填充
     DB    (2*100+1) MOD 101,(2*85+1)MOD 101,(2*80+1) MOD 101,?    ;平均成绩还未计算
     DB  'l' XOR 'z','i' XOR 'j','s' XOR 'h','i' XOR 'z', 6 DUP(0)
     DB    (2*90+1) MOD 101,(2*79+1)MOD 101,(2*99+1) MOD 101,?
     DB  's' XOR 'z','c' XOR 'j','j' XOR 'h',7 DUP(0)
     DB    (2*80+1) MOD 101,(2*16+1)MOD 101,(2*66+1) MOD 101,?

BUF_PASSWORD  DB  5 XOR 'S'       ;密码串的长度为3，采用与常数43H异或的方式编码成密文
     DB  'z' XOR 'z'    ;真实密码为zzjzh。采用循环异或zjh进行编码。
     DB  'z' XOR 'j'
     DB  'j' XOR 'h'
     DB  'z' XOR 'z'
     DB  'h' XOR 'j'     
     DB  's' XOR 'h'

IN_PASSWORD  DB 10             ;使用者输入的密码区，最大长度6个字符
        DB ?
        DB 10 DUP(0)

P1      DW  PASS             ;地址表（用于间接转移反跟踪）
ADDR2      DW  RETU1
;ADDR3      DW  PASS2   
IN_NAME DB 15
     DB ?
     DB 15 DUP(0)
     POIN DW 0
     QUO  DW 2
     FAC  DB 7
     FAC1 DB 14
     TEMP DW 0
DATA ENDS

CODE SEGMENT USE16
     ASSUME CS:CODE,DS:DATA,SS:STACK

     NEWINT: 
     MOV P,2
     iret


 EQ10:XOR BL,'z'
      mov  DX,[esp]           ;把栈顶上面的字（PASS2的地址）取到
      sti
      jmp  DX         

 EQ11:XOR BL,'j'
      JMP RETU1
 EQ12:XOR BL,'h'
      JMP RETU1
 EQ20:XOR DH,'z'
      JMP RETU2
 EQ21:XOR DH,'j'
      JMP RETU2
 EQ22: XOR DH,'h'
      JMP RETU2

WP:   LEA DX,W_PASSWORD
      MOV AH,9
      INT 21H
      JMP BEGIN

START:MOV AX,DATA
      MOV DS,AX

xor  ax,ax                  ;接管调试用中断，中断矢量表反跟踪
     mov  es,ax
     mov  ax,es:[1*4]            ;保存原1号和3号中断矢量
       mov  OLDINT1,ax
       mov  ax,es:[1*4+2]
       mov  OLDINT1+2,ax
       mov  ax,es:[3*4]
       mov  OLDINT3,ax
       mov  ax,es:[3*4+2]
       mov  OLDINT3+2,ax
       cli                           ;设置新的中断矢量
       mov  ax,OFFSET NEWINT
       mov  es:[1*4],ax
       mov  es:[1*4+2],cs
       mov  es:[3*4],ax
       mov  es:[3*4+2],cs
       sti

BEGIN:LEA DX,T_PASSWORD
      MOV AH,9
      INT 21H
      
      LEA DX,IN_PASSWORD               ;输入密码字符串
      MOV AH,10
      INT 21H

      cli                       ;计时反跟踪开始 
      mov  ah,2ch 
      int  21h
      push dx 
      nop
      nop
      nop
      mov ah,IN_PASSWORD+2
      MOV CL,IN_PASSWORD+1
      CMP CL,1
      
      JNE XORS 
      MOV AL,IN_PASSWORD+2
      CMP AL,'q'
      JE FINISH
XORS: XOR CL,'S'
      CMP CL,BUF_PASSWORD[0]
      pushfd
      mov  ah,2ch                 ;获取第二次秒与百分秒
      int  21h
      sti
      cmp  dx,[esp]               ;计时是否相同
      popfd
      pop  dx
      mov cl,0
      JNE WP
      
      
      
TESTP:MOV DI,0
      MOV SI,0
LOPP: INC DI
      INC SI
      CMP SI,6
      JE PASS
      MOV BL,IN_PASSWORD[SI+1]
      MOV AX,SI
      MOV CL,P
      DIV CL
      MOV AL,3
      ;INC SI
      CMP DI,6
      JE PASS
      CMP AH,1
      cli                       ;堆栈检查反跟踪
      push  ADDR2
      JE  EQ10
      CMP AH,2
      JE EQ11
      CMP AH,0
      JE EQ12
RETU1:CMP BL,BUF_PASSWORD[SI]
      JNE WP
      JMP LOPP



PASS: LEA DX,BUF_STRING
      MOV AH,9
      INT 21H

      MOV DL,0AH
      MOV AH,2
      INT 21H

      LEA DX,IN_NAME
      MOV AH,10
      INT 21H

      

      ;MOV SI,OFFSET IN_NAME
      MOV AL,BYTE PTR IN_NAME[2]
      MOV BL,BYTE PTR IN_NAME[1]
      CMP BL,1H
      JNE FLAG
      CMP AL,0DH
      JE BEGIN
      CMP AL,71H
      JE FINISH
      CMP AX,51H
      JE FINISH
FLAG: MOV CX,0
      MOV BX,0
LOP1: MOV SI,0
      MOV AL,0
      INC CX
      CMP CX,N1
      JE BEGIN
      ADD BX,14
LOP2: MOV DL,BYTE PTR BUF_DATA[BX-14][SI]
      MOV DH,BYTE PTR IN_NAME[SI+2]
      PUSH AX
      MOV AX,SI
      PUSH CX
      MOV CL,3
      DIV CL
      POP CX
      CMP AH,0
      JE EQ20
      CMP AH,1
      JE EQ21
      CMP AH,2
      JE EQ22 
RETU2:POP AX
      CMP DL,DH      
      JNE LOP1
      INC SI
      INC AL 
      CMP AL,BYTE PTR IN_NAME+1
      JNE LOP2
      CMP AL,10
      JE FLAG1
      CMP BUF_DATA[BX-14][SI+1],0
      JNE LOP1
FLAG1:LEA DI,BUF_DATA[BX-14][0]
      MOV POIN,DI

      MOV TEMP,CX
      DEC TEMP

      
      MOV CX,0
      MOV DX,0
      MOV BX,0
 FUN3:MOV SI,0AH
      MOV DX, BYTE PTR BUF_DATA[BX][SI]
      MOV DH,0
      CALL DECODE
      ADD DX,DX
      MOV AX,0
      MOV AX,BYTE PTR BUF_DATA[BX][SI+1]
      MOV AH,0
      ADD DX,AX
      MOV AX,0
      MOV AX,BYTE PTR BUF_DATA[BX][SI+2]
      MOV AH,0
      SHR AX,1
      ADD DX,AX
      MOV AX,DX
      SHL AX,1
      DIV FAC
      MOV BYTE PTR BUF_DATA[BX][SI+4],AL
      ADD BX,13
      INC CX
      CMP CX,N
      JNE FUN3

FUN4: 
      MOV DL,0AH
      MOV AH,2
      INT 21H
      MOV SI,0EH
      MOV BX,TEMP
      MUL FAC1
      MOV AL,BYTE PTR BUF_DATA[BX][SI]
      CMP BYTE PTR BUF_DATA[BX][SI],90
      JAE SH_A
      CMP BUF_DATA[BX][SI],80
      JAE SH_B
      CMP BUF_DATA[BX][SI],70
      JAE SH_C
      CMP BUF_DATA[BX][SI],60
      JAE SH_D
      MOV DL,46H
      MOV AH,2
      INT 21H
      JMP BEGIN

SH_A: MOV DL,41H
      MOV AH,2
      INT 21H
      JMP BEGIN

SH_B: MOV DL,42H
      MOV AH,2
      INT 21H
      JMP BEGIN

SH_C: MOV DL,43H
      MOV AH,2
      INT 21H
      JMP BEGIN

SH_D: MOV DL,44H
      MOV AH,2
      INT 21H
      JMP BEGIN




FINISH:cli                           ;还原中断矢量
       mov  ax,OLDINT1
       mov  es:[1*4],ax
       mov  ax,OLDINT1+2
       mov  es:[1*4+2],ax
       mov  ax,OLDINT3
       mov  es:[3*4],ax
       mov  ax,OLDINT3+2
       mov  es:[3*4+2],ax 
       sti
       MOV AH,4CH
       INT 21H

DECODE PROC
       PUSHA
       DEC DL
       MOV DH,0
       IMUL DX,51
       MOV AX,DX
       MOV CL,101
       DIV CL
       MOV DL,AH
       POPA
       RET
DECODE ENDP

CODE   ENDS
       END START
       
        