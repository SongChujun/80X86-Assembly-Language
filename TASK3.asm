.386
STACK SEGMENT USE16 STACK
      DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
BUF_STRING DB 0AH,0DH,'Press any key to begin! $'
BUF1 DB 0,1,2,3,4,5,6,7,8,9
BUF2 DB 10 DUP(0)
BUF3 DB 10 DUP(0)
BUF4 DB 10 DUP(0) 
DATA ENDS
CODE SEGMENT USE16
     ASSUME CS:CODE,DS:DATA,SS:STACK
START: MOV AX,DATA
       MOV DS,AX
       LEA DX,BUF_STRING
       MOV AH,9
       INT 21H

       MOV AH,1
       INT 21H

       
       MOV SI,OFFSET BUF1;
       MOV DI,OFFSET BUF2;
       MOV BX,OFFSET BUF3;
       MOV BP,OFFSET BUF4;

       MOV CX,10
       
LOPA:  MOV AL,[SI]
       MOV [DI],AL     
       INC AL
       MOV [BX],AL
       ADD AL,3
       MOV DS:[BP],AL

       INC SI
       INC DI
       INC BP
       INC BX
       DEC CX
       JNZ LOPA
       MOV AH,4CH
       INT 21H
CODE   ENDS
       END START