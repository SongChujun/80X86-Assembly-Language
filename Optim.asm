.386

STACK SEGMENT USE16 STACK
      DB 10 DUP(0)
STACK ENDS

DATA SEGMENT USE16

;timestr db 8 dup(0)
BUF_STRING DB 0AH,0DH,'Please enter the name of the student you want to query,enter q to quit! $'
;CRLF DB 0DH,0AH,'$'

M    EQU 1000
N    EQU   30
N1   EQU   N+1
N2   DD ?;14*(N+1)
N3   DD ?;14*N




BUF_DATA  DB  'zhangsan',0,0   ;学生姓名，不足10个字节的部分用0填充
     DB    100,100,100,?    ;平均成绩还未计算
     DB  'lisi',6 DUP(0)
     DB    80, 100, 70,?
     DB   N-3 DUP( 'TempValue',0,80,90,95,?) ;除了3个已经具体定义了学生信息的成绩表以外，其他学生的信息暂时假定为一样的。
     DB  'songchujun';最后一个必须是自己名字的拼音
     DB    100, 60, 60, ?
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

      MOV EAX,N

      MUL FAC1
      MOV N3,EAX

      MOV EAX,N
      INC EAX
      MUL FAC1
      MOV N2,EAX


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
      MOV BP,0
FLAG: ;CALL disptime
      MOV AX,0
       CALL TIMER
ANCH: ;MOV CX,0
      MOV EBX,0
LOP1: MOV ESI,0
      MOV AL,0
      ;INC CX
      ;CMP CX,N1
      ;JE BEGIN
      ADD EBX,14
      CMP EBX,N2
      JE BEGIN
LOP2: MOV DL, BUF_DATA[EBX-14][ESI]
      CMP DL, IN_NAME[ESI+2]
      JNE LOP1
      INC ESI
      INC AL 
      CMP AL, BYTE PTR IN_NAME[1]
      JNE LOP2
      CMP AL,0AH
      JE FLAG1
      CMP BYTE PTR BUF_DATA[EBX-14][ESI],0
      JNE LOP1
FLAG1:LEA DI,BUF_DATA[EBX-14][0]
      MOV DS:[POIN],DI
      ;MOV TEMP,CX
      ;DEC TEMP
      
      ;MOV CX,0
      MOV DX,0
      MOV EBX,0
 FUN3:MOV ESI,0AH
      MOV DL,BYTE PTR BUF_DATA[EBX][ESI]
      MOV DH,0
      SHL DX,1
      ;MOV AX,0
      MOV AL,BYTE PTR BUF_DATA[EBX][ESI+1]
      MOV AH,0
      ADD DX,AX
      MOV AL,BYTE PTR BUF_DATA[EBX][ESI+2]
      MOV AH,0
      SHR AX,1
      ADD DX,AX
      MOV AX,DX
      SHL AX,1
      DIV FAC
      MOV BYTE PTR BUF_DATA[EBX][ESI+3],AL
      ADD EBX,14
  
      
      ;INC CX
      CMP EBX,N3
      JNE FUN3
      INC BP
      CMP BP,1000
      JNE ANCH
      MOV AX,1  
      CALL TIMER
      ;call disptime
FUN4: 
      MOV DL,0AH
      MOV AH,2
      INT 21H
      MOV SI,0EH
      MOV BX,TEMP
      MUL FAC1
      MOV AL,BYTE PTR DS:[POIN+0DH]
      CMP AL,90
      JAE SH_A
      CMP AL,80
      JAE SH_B
      CMP AL,70
      JAE SH_C
      CMP AL,60
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



TIMER PROC
  PUSH  DX
  PUSH  CX
  PUSH  BX
  MOV   BX, AX
  MOV   AH, 2CH
  INT   21H      ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
  MOV   AL, DH
  MOV   AH, 0
  IMUL  AX,AX,1000
  MOV   DH, 0
  IMUL  DX,DX,10
  ADD   AX, DX
  CMP   BX, 0
  JNZ   _T1
  MOV   CS:_TS, AX
_T0:  POP   BX
  POP   CX
  POP   DX
  RET
_T1:  SUB   AX, CS:_TS
  JNC   _T2
  ADD   AX, 60000
_T2:  MOV   CX, 0
  MOV   BX, 10
_T3:  MOV   DX, 0
  DIV   BX
  PUSH  DX
  INC   CX
  CMP   AX, 0
  JNZ   _T3
  MOV   BX, 0
_T4:  POP   AX
  ADD   AL, '0'
  MOV   CS:_TMSG[BX], AL
  INC   BX
  LOOP  _T4
  PUSH  DS
  MOV   CS:_TMSG[BX+0], 0AH
  MOV   CS:_TMSG[BX+1], 0DH
  MOV   CS:_TMSG[BX+2], '$'
  LEA   DX, _TS+2
  PUSH  CS
  POP   DS
  MOV   AH, 9
  INT   21H
  POP   DS
  JMP   _T0
_TS DW    ?
  DB    'Time elapsed in ms is '
_TMSG DB    12 DUP(0)
TIMER   ENDP



CODE   ENDS
       END START
