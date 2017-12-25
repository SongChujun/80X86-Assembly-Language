;INSERT MODULE
;TO GET STUDENTS' NAMES AND GRADES
        NAME INSERT
        EXTRN TAB : BYTE, BUF : BYTE, CRLF : BYTE, CHECK_NAME : NEAR
        PUBLIC INSERT, WRONG_NAME
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

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
  ORDER DB 'STUDENT ', 0, ':', 0DH, 0AH, '$'
  IN_NAME DB 10 DUP(' '), 'THE STUDENT', 27H, 'S NAME: $'
  CHINESE DB 10 DUP(' '), 'CHINESE SCORE: $'
  MATH DB 10 DUP(' '), 'MATH SCORE: $'
  ENGLISH DB 10 DUP(' '), 'ENGLISH SCORE: $'
  SCORE DB 2 DUP(0)
  SIGN DB 0
  WRONG_NAME DB 10 DUP(' '), 'THE NAME MUST BE ENGLISH LETTERS!$'
  BAD_SCORE DB 10 DUP(' '), 'SCORES MUST BE BETWEEN 0 AND 100!', 0DH, 0AH, '$'
DATA ENDS

CODE SEGMENT USE16 PARA PUBLIC 'CODE'
  ASSUME CS : CODE, DS : DATA
INSERT PROC NEAR
  PUSH CX
  PUSH BX
  PUSH AX
  MOV CX, 1
  LEA BX, TAB
BEGIN :
  PUSH CX
  ADD CL, 30H
  MOV ORDER+8, CL
  POP CX
  SHOW ORDER
GET_NAME :
  SHOW IN_NAME
  GETS BUF
  SHOW CRLF
  CALL CHECK_NAME
  CMP AX, 0
  JE GET_NAME
RETRY1 :
  SHOW CHINESE
  GETS BUF
  SHOW CRLF
  CALL CHECK_SCORE
  CMP AH, -1
  JE RETRY1
  MOV 10[BX], AL
RETRY2 :
  SHOW MATH
  GETS BUF
  SHOW CRLF
  CALL CHECK_SCORE
  CMP AH, -1
  JE RETRY2
  MOV 11[BX], AL
RETRY3 :
  SHOW ENGLISH
  GETS BUF
  SHOW CRLF
  CALL CHECK_SCORE
  CMP AH, -1
  JE RETRY3
  MOV 12[BX], AL
  ADD BX, 16
  INC CX
  CMP CX, 5
  JNA BEGIN
  POP AX
  POP BX
  POP CX
  RET
INSERT ENDP
F10T2 PROC
  PUSH EBX
  MOV EAX, 0
  MOV SIGN, 0
  MOV BL, [SI]
  CMP BL, '+'
  JE F10
  CMP BL, '-'
  JNE NEXT2
  MOV SIGN, 1
F10 :
  DEC CX
  JZ ERR
NEXT1 :
  INC SI
  MOV BL, [SI]
NEXT2 :
  CMP BL, '0'
  JB ERR
  CMP BL, '9'
  JA ERR
  SUB BL, 30H
  MOVZX EBX, BL
  IMUL EAX, 10
  JO ERR
  ADD EAX, EBX
  JO ERR
  JS ERR
  JC ERR
  DEC CX
  JNZ NEXT1
  CMP DX, 16
  JNZ PP0
  CMP EAX, 7FFFH
  JA ERR
PP0 :
  CMP SIGN, 1
  JNE QQ
  NEG EAX
QQ :
  POP EBX
  RET
ERR :
  MOV SI, -1
  JMP QQ
F10T2 ENDP
CHECK_SCORE PROC
  PUSH SI
  PUSH CX
  PUSH DX
  CMP BUF+2, '-'
  JE WRONG_SCORE
  CMP BUF+2, '1'
  JNE GOON
  CMP BUF+3, '0'
  JNE GOON
  CMP BUF+4, '0'
  JNE GOON
  MOV AL, 100
  JMP GOOD_SCORE
GOON :
  CMP BUF+3, 0DH
  JNE TWO
  MOV DL, BUF+2
  MOV SCORE, DL
  MOV CX, 1
  JMP TOCALL
TWO :
  CMP BUF+4, 0DH
  JNE WRONG_SCORE
  MOV DL, BUF+2
  MOV SCORE, DL
  MOV DL, BUF+3
  MOV SCORE+1, DL
  MOV CX, 2
TOCALL :
  LEA SI, SCORE
  MOV DX, 16
  CALL F10T2
  CMP SI, -1
  JNE GOOD_SCORE
WRONG_SCORE :
  PUSH AX
  SHOW BAD_SCORE
  POP AX
  MOV AH, -1
  JMP IN_EXIT
GOOD_SCORE :
  MOV AH, 0
IN_EXIT :
  POP DX
  POP CX
  POP SI
  RET
CHECK_SCORE ENDP
CODE ENDS
  END
