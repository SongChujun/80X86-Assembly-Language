;MAIN MODULE
;DISPLAY MAIN MENU AND CALL SUBFUNCTIONS
        NAME MAIN
        EXTRN RANK :NEAR, INSERT : NEAR, AVERAGE : NEAR, PRINT : NEAR
        PUBLIC TAB, BUF_RANKING, BUF, CRLF
.386

SHOW MACRO S
  LEA DX, S
  MOV AH, 9
  INT 21H
  ENDM

GETS MACRO B
  LEA DX, B
  MOV AH, 10
  INT 21H
  ENDM

STACK SEGMENT STACK USE16 STACK 'STACK'
  DB 200 DUP(0)
STACK ENDS

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
  ;TAB DB 5 DUP(10 DUP(0), 4 DUP(0), 2 DUP(0))
  ;TAB  DB  'zhangsan',0,0, 100, 85, 80,99,0,0
  ;     DB  'lisi',6 DUP(0),80, 100, 70,100,0,0
  ;     DB    'wangwu',0,0,0,0, 85,100,60,98,0,0
  ;     DB    'zhaoliu',0,0,0, 85,100,60,96,0,0
  ;     DB    'hanqi',0,0,0,0,0,90,90,90,98,0,0
  TAB  DB (('Z' XOR '5') - 1CH)*2
       DB (('H' XOR '2') - 1CH)*2
       DB (('U' XOR 'A') - 1CH)*2
       DB (('J' XOR 'C') - 1CH)*2
       DB (('H' XOR 'M') - 1CH)*2
       DB 5 DUP(0)
       DB ((100 XOR '5') - 1CH)*2
       DB ((85 XOR '2') - 1CH)*2
       DB ((80 XOR 'A') - 1CH)*2
       DB 0, 0, 0
       ;LISI
       DB (('L' XOR '5') - 1CH)*2
       DB (('I' XOR '2') - 1CH)*2
       DB (('S' XOR 'A') - 1CH)*2
       DB (('I' XOR 'C') - 1CH)*2
       DB 6 DUP(0)
       DB ((80 XOR '5') - 1CH)*2
       DB ((100 XOR '2') - 1CH)*2
       DB ((70 XOR 'A') - 1CH)*2
       DB 0, 0, 0
       ;WANGW
       DB (('W' XOR '5') - 1CH)*2
       DB (('A' XOR '2') - 1CH)*2
       DB (('N' XOR 'A') - 1CH)*2
       DB (('G' XOR 'C') - 1CH)*2
       DB (('W' XOR 'M') - 1CH)*2
       DB 5 DUP(0)
       DB ((85 XOR '5') - 1CH)*2
       DB ((100 XOR '2') - 1CH)*2
       DB ((60 XOR 'A') - 1CH)*2
       DB 0, 0, 0
       ;DB  'lisi',6 DUP(0),80, 100, 70,100,0,0
       ;DB    'wangwu',0,0,0,0, 85,100,60,98,0,0
  ;     DB    'zhaoliu',0,0,0, 85,100,60,96,0,0
  ;     DB    'hanqi',0,0,0,0,0,90,90,90,98,0,0
  PWD DB 6 XOR '9'
      DB ('A' - 0C1H)*2 XOR 'P'
      DB ('S' - 0C1H)*2 XOR 'A'
      DB ('P' - 0C1H)*2 XOR 'S'
      DB ('L' - 0C1H)*2 XOR 'S'
      DB ('O' - 0C1H)*2 XOR 'W'
      DB ('S' - 0C1H)*2 XOR 'D'
      DB 0C7H, 0DDH, 23H
  ;IN_PWD DB 10
  ;       DB ?
  ;       DB 10 DUP(0)
  GET_PWD DB 0DH, 0AH, 'PLEASE ENTER PASSWORD: $'
  P1 DW PASS1
  P2 DW PASS2
  E1 DW OVER
  P3 DW PASS3
  OLDINT1 DW 0, 0
  OLDINT3 DW 0, 0
  MENU DB 20 DUP(' '), 42 DUP('*'), 0DH, 0AH
       DB 20 DUP(' '), '*                  MENU                  *', 0DH, 0AH
       DB 20 DUP(' '), '*       1.CACULATE AVERAGE SCORES        *', 0DH, 0AH
       DB 20 DUP(' '), '*       2.CACULATE RANKING               *', 0DH, 0AH
       DB 20 DUP(' '), '*       3.QUERY GRADES                   *', 0DH, 0AH
       DB 20 DUP(' '), '*       4.EXIT                           *', 0DH, 0AH
       DB 20 DUP(' '), 42 DUP('*'), 0DH, 0AH
       DB 'ENTER NUMBER TO SELECT: $'
  BAD_SELECT DB 'INPUT NUMBER 0~5!', 0DH, 0AH, '$'
  BUF DB 10
      DB ?
      DB 10 DUP(0)
  BUF_RANKING DB 5 DUP(0)
  CRLF DB 0DH, 0AH, '$'
  KEY DB 'PASSWD'
  PRI_KEY DB '52ACM'
  QUERY_NAME DB 'ENTER NAME: $'
  POIN DW 0, 0
  NONE DB 'NO SUCH A STUDENT!',0DH,0AH,'$'
DATA ENDS

CODE SEGMENT USE16 PARA PUBLIC 'CODE'
  ASSUME DS : DATA, SS : STACK, CS : CODE
START :
  MOV AX, DATA
  MOV DS, AX
  ;输入密码
  SHOW GET_PWD
  GETS BUF
  CALL CHECK_PWD
  MOV CL, BUF+1
  XOR CL, '9'
  MOVZX AX, CL
  MOVZX DX, PWD
  SUB AX, DX
  ADD AX, OFFSET P1
  MOV BX, AX
  ;MOV BX, OFFSET E1
OK1:MOV BX, [BX]
    ADD BX, 10
    CMP BX, ERR3
    JZ OK2
    JMP E1
OK2:SUB BX, 10
    JMP BX
    DB 'NO WAY TO GO'

PASS1:MOVZX CX, BUF+1
      MOV SI, 0
      MOV DL, 2
ERR3: DW E1
      DB 'YOU ARE CLOSE TO THE PASSWORD'
PASS2:MOVZX AX, BUF+2[SI]
      SUB  AX, 0C1H
      MUL  DL
      XOR AL, KEY[SI]
      CMP  AL,PWD+1[SI]
      JNZ  ERR2
      INC  SI
      LOOP PASS2
      JMP  PASS3
      DB 'YOU HAVE GOT THE PASSWORD!'
ERR2: MOV EBX, OFFSET P1
      MOV EDX, 1
      JMP WORD PTR [EBX+EDX*4]
PASS3:MOV BX, ES:[1*4]
      INC BX
      JMP BX
      DB 'YOU HAVE REACHED THE GATE'
PASS4:
SELECT :
  SHOW MENU
  GETS BUF
  SHOW CRLF
  MOV AL, BUF+2
  SUB AL, 31H
  JZ FUN2
  DEC AL
  JZ FUN3
  DEC AL
  JZ FUN4
  DEC AL
  JZ EXIT
  SHOW BAD_SELECT
  JMP SELECT
FUN1 :
  JMP OVER
  CALL INSERT
  SHOW CRLF
  JMP SELECT
FUN2 :
  DB 'YOU SHOULD KNOW THE CORRECT PASSWORD'
  CALL AVERAGE
  SHOW CRLF
  JMP SELECT
FUN3 :
  DB 'CONGRATULATIONS!'
  CALL RANK
  SHOW CRLF
  JMP SELECT
FUN4 :
  DB 'YOU CANNOT GET THE GRADE UNTIL YOU GET TO KNOW THE CORRECT PASSWORD'
  CALL QUERY
  SHOW CRLF
  JMP SELECT
NEWINT:IRET
TESTINT:JMP PASS4
OVER:
  CLI
  MOV AX, OLDINT1
  MOV ES:[1*4], AX
  MOV AX, OLDINT1+2
  MOV ES:[1*4+2], AX
  MOV AX, OLDINT3
  MOV ES:[3*4], AX
  MOV AX, OLDINT3+2
  MOV ES:[3*4+2], AX
  STI
EXIT :
  MOV AH, 4CH
  INT 21H
CHECK_PWD PROC
  PUSH SI
  PUSH CX
  PUSH BX
  PUSH AX
  PUSH DX
  LEA SI,TAB
  MOV CX,5
  AVE :
  MOVZX BX,BYTE PTR 10[SI]
  SHL BX,1
  MOVZX AX,BYTE PTR 11[SI]
  ADD BX,AX
  MOVZX AX,BYTE PTR 12[SI]
  SHR AX,1
  ADD AX,BX
  SHL AX,1
  MOV DL,7
  DIV DL
  MOV 13[SI],AL
  ADD SI,16
  LOOP AVE
  POP DX
  POP AX
  POP BX
  POP CX
  POP SI
  RET
CHECK_PWD ENDP
QUERY PROC
GET_NAME:SHOW QUERY_NAME
  GETS BUF
  MOV CX,3
	LEA BX,TAB
SEARCH :
	CALL STRCMP
	CMP AL,0
	JZ FOUND
	ADD BX,16
	LOOP SEARCH
	LEA DX,NONE
	MOV AH,9
	INT 21H
	JMP GET_NAME
FOUND :
	MOV POIN,BX
  RET
QUERY ENDP
STRCMP PROC
	PUSH CX
	MOV CX,10
	MOV SI,0
	MOV AL,0
COM :
  MOV AH, BUF+2[SI]
  XOR AH, PRI_KEY[SI]
  SUB AH, 1CH
  SHL AH, 1
	SUB AH,[BX+SI]
	OR AL,AH
	CMP AL,0
	JNZ BREAK2
	INC SI
	LOOP COM
BREAK2 :
	POP CX
	RET
STRCMP ENDP
CODE ENDS
  END START
