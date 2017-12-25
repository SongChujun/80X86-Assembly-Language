											;subroutine sort
;function: sort the items in BUF_DATA according to their GPA from the hignest to lowest
;the result will be put in BUF_RANKING and the rankings will be put in the last word in each item
;input parameter:NO
;output parameter:the sorted GPAS and their rannking in BUF_DATA
		;NAME RANK
.model small
.DATA
BUF_RANKING DB 5 DUP(0)
.code
public _RANK
_RANK PROC NEAR

PUSH AX
PUSH DX
PUSH CX
PUSH DI
PUSH SI
PUSH BP
MOV BP,SP


MOV  DI,SS:[BP+14]
MOV  SI,OFFSET BUF_RANKING

MOV CX, 5;5 is the number of items to be ranked

LOPMV: MOV DL,[DI+13];the loop to move the avg garde to BUF_RANKING
	   MOV [SI],DL
	   ADD DI,16
	   INC SI
	   DEC CX
	   CMP CX,0
	   JNE LOPMV

	   MOV CX,4
LOPSOT:MOV DX,CX;the outer loop of the sort part
	   LEA SI,BUF_RANKING
LOPSIN:MOV AL,[SI];the inner loop of the sort part
	   CMP AL,[SI+1]
	   JA NOXCH
XCH:   XCHG [SI+1],AL;change
	   MOV  [SI],AL
NOXCH: ADD SI,1;no change
	   DEC DX
	   JNE LOPSIN
	   LOOP LOPSOT

       MOV BX,SS:[BP+14]
	   MOV SI,0
LOPOT: MOV AL,BUF_RANKING[SI]
	   MOV DI,0
	   INC SI
	   CMP SI,6
	   JE FINISHED
	   MOV CX,0
LOPIN: INC CX
	   CMP CX,6
	   JE LOPOT
	   ADD DI,16
	   CMP AL,DS:[BX][DI-3]
	   JNE LOPIN
	   CMP BYTE PTR DS:[BX][DI-2],0
	   JNE LOPIN
	   MOV WORD PTR DS:[BX][DI-2],SI
	   JMP LOPIN
FINISHED :
POP BX
POP SI
POP DI
POP CX
POP DX
POP AX
RET
_RANK ENDP
END																																																																																																																																																																																																													
