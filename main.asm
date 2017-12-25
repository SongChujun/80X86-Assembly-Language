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

STACK SEGMENT USE16 PUBLIC 'STACK'
  DB 200 DUP(0)
STACK ENDS

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
  TAB DB 5 DUP(10 DUP(0), 4 DUP(0), 2 DUP(0))
  ;TAB  DB  'zhangsan',0,0, 100, 85, 80,99,0,0
  ;     DB  'lisi',6 DUP(0),80, 100, 70,100,0,0
  ;     DB    'wangwu',0,0,0,0, 85,100,60,98,0,0
  ;     DB    'zhaoliu',0,0,0, 85,100,60,96,0,0
  ;     DB    'hanqi',0,0,0,0,0,90,90,90,98,0,0
  MENU DB 20 DUP(' '), 42 DUP('*'), 0DH, 0AH
       DB 20 DUP(' '), '*                  MENU                  *', 0DH, 0AH
       DB 20 DUP(' '), '*   1.INSERT STUDENTS NAMES AND SCORES   *', 0DH, 0AH
       DB 20 DUP(' '), '*   2.CACULATE AVERAGE SCORES            *', 0DH, 0AH
       DB 20 DUP(' '), '*   3.CACULATE RANKING                   *', 0DH, 0AH
       DB 20 DUP(' '), '*   4.EXPORT TRANSCRIPTS                 *', 0DH, 0AH
       DB 20 DUP(' '), '*   5.EXIT                               *', 0DH, 0AH
       DB 20 DUP(' '), 42 DUP('*'), 0DH, 0AH
       DB 'ENTER NUMBER TO SELECT: $'
  BAD_SELECT DB 'INPUT NUMBER 0~5!', 0DH, 0AH, '$'
  BUF DB 10
      DB ?
      DB 10 DUP(0)
  BUF_RANKING DB 5 DUP(0)
  CRLF DB 0DH, 0AH, '$'
DATA ENDS

CODE SEGMENT USE16 PARA PUBLIC 'CODE'
  ASSUME DS : DATA, SS : STACK, CS : CODE
START :
  MOV AX, DATA
  MOV DS, AX
SELECT :
  SHOW MENU
  GETS BUF
  SHOW CRLF
  MOV AL, BUF+2
  SUB AL, 31H
  JZ FUN1
  DEC AL
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
  CALL INSERT
  SHOW CRLF
  JMP SELECT
FUN2 :
  CALL AVERAGE
  SHOW CRLF
  JMP SELECT
FUN3 :
  CALL RANK
  SHOW CRLF
  JMP SELECT
FUN4 :
  CALL PRINT
  SHOW CRLF
  JMP SELECT
EXIT :
  MOV AH, 4CH
  INT 21H
CODE ENDS
  END START
