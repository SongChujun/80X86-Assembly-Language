;subroutine sort
;function: sort the items in BUF_DATA according to their GPA from the hignest to lowest
;the result will be put in BUF_RANKING and the rankings will be put in the last word in each item
;input parameter:NO
;output parameter:the sorted GPAS and their rannking in BUF_DATA
        NAME RANK
        EXTRN  TAB:BUTE,BUF_RANKING : BYTE
        PUBLIC RANK
.386
;EXTRN  TAB:BUTE,BUF_RANKING : BYTE
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
;ASSUME CS:CODE
RANK PROC
PUSH AX
PUSH DX
PUSH CX
PUSH DI
PUSH SI

MOV  DI,OFFSET TAB
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
       CMP AL,TAB[DI-3]
       JNE LOPIN
       CMP BYTE PTR TAB[DI-2],0
       JNE LOPIN
       MOV WORD PTR TAB[DI-2],SI
       JMP LOPIN
FINISHED :
POP SI
POP DI
POP CX
POP DX
POP AX
RET
RANK ENDP
CODE ENDS
     END
