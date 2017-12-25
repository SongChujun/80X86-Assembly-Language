.386

STACK SEGMENT USE16 STACK
      DB 10 DUP(0)
STACK ENDS

DATA SEGMENT USE16

BUF_STRING DB 0AH,0DH,'Please enter the name of the student you want to query,enter q to quit! $'
;CRLF DB 0DH,0AH,'$'


N    EQU   30
N1   EQU   N+1




BUF_DATA  DB  'zhangsan',0,0   ;学生姓名，不足10个字节的部分用0填充
     DB    100,85,80,?    ;平均成绩还未计算
     DB  'lisi',6 DUP(0)
     DB    80, 100, 70,?
     DB   N-3 DUP( 'TempValue',0,80,90,95,?) ;除了3个已经具体定义了学生信息的成绩表以外，其他学生的信息暂时假定为一样的。
     DB  'songchujun';最后一个必须是自己名字的拼音
     DB    85, 85, 100, ?
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
START:MOV AX,DATA
      MOV DS,AX

BEGIN:LEA DX,BUF_STRING
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
      CMP DL,BYTE PTR IN_NAME[SI+2]
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




FINISH:MOV AH,4CH
       INT 21H



CODE   ENDS
       END START
