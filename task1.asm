            .386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
AvgRnk   proto
shiftg    proto

include      menuID.INC

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

student	     struct
	     myname   db  10 dup(20h)
	     chinese  db  0
	     math     db  0
	     english  db  0
	     average  db  0
	     grade    db  0
student      ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'ACM1501 Chujun SONG',0
hInstance    dd       0
CommandLine  dd       0
buf	     student  <'zhangsan',98,88,68,89,'B'>
	     student  <'lisi',96,98,100,98,'A'>
	     student  <'wangwu',96,98,23,98,'C'>
		 student  <'zhaoliu',96,98,56,98,'D'>
		 student  <'song',96,10,100,98,'F'>
msg_name     db       'name',0
msg_chinese  db       'chinese',0
msg_math     db       'math',0
msg_english  db       'english',0
msg_average  db       'average',0
msg_grade    db       'grade',0
chinese	     db       2,0,0,0, '96'
math	     db       2,0,0,0, '98'
english	     db       3,0,0,0, '100'
average	     db       2,0,0,0, '98'
fac7          db  7
fac10        db  10 
show_grade   db 70 dup(20h)

.code
Start:	 invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND

         invoke RtlZeroMemory,addr wc,sizeof wc

	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax

	     invoke RegisterClassEx, addr wc
	     invoke CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL

	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	      LOCAL  hdc:HDC
            LOCAL  hDC:DWORD
            LOCAL Ps :PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
		.ELSEIF wParam == IDM_FILE_AVERAGE
		    invoke AvgRnk
	    .ELSEIF wParam == IDM_FILE_LIST
		    invoke Display,hWnd
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
	     ;;redraw window again
           invoke BeginPaint,hWnd,ADDR Ps
            ;mov hDC, eax
            invoke EndPaint,hWnd,ADDR Ps
            xor eax, eax
            ret
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc   hWnd:DWORD
       
             
             
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             LOCAL  hdc:HDC
	       local  cnt:word
             push ebp
             MOV ebx,0
             mov ebp,0
     move: mov ah,0
            MOV al,byte ptr buf[ebx][10]
            invoke shiftg
            .IF al == 101
            mov ds:show_grade[ebp][0],49
            mov ds:show_grade[ebp][1],48
            mov ds:show_grade[ebp][2],48
            .ELSE
            mov  ds:show_grade[ebp][1],ah
            mov  ds:show_grade[ebp][2],al
            .ENDIF
            mov ah,0
            MOV AL,BYTE PTR buf[ebx][11]
            invoke shiftg
            .IF al ==101
            mov ds:show_grade[ebp][3],49
            mov ds:show_grade[ebp][4],48
            mov ds:show_grade[ebp][5],48
            .ELSE
            mov  ds:show_grade[ebp][4],ah
            mov  ds:show_grade[ebp][5],al
            .ENDIF
            mov ah,0
            MOV AL,BYTE PTR buf[ebx][12]
            invoke shiftg
            .IF al ==101
            mov ds:show_grade[ebp][6],49
            mov ds:show_grade[ebp][7],48
            mov ds:show_grade[ebp][8],48
            .ELSE
            mov ds:show_grade[ebp][7],ah
            mov ds:show_grade[ebp][8],al
            .ENDIF
            mov ah,0
            MOV AL,BYTE PTR buf[ebx][13]
            invoke shiftg
            .IF al ==101
            mov ds:show_grade[ebp][9],49
            mov ds:show_grade[ebp][10],48
            mov ds:show_grade[ebp][11],48
            .ELSE
            mov ds:show_grade[ebp][10],ah
            mov ds:show_grade[ebp][11],al
            .ENDIF
            
            ADD ebx,15
            ADD ebp,12
            CMP ebx,75
            JNE move
            
LIST MACRO  A,B,C
            invoke TextOut,hdc,XX+0*XX_GAP,YY+A*YY_GAP,offset buf[B*15].myname,10
            invoke TextOut,hdc,XX+1*XX_GAP,YY+A*YY_GAP,offset show_grade[12*C+0],3
            invoke TextOut,hdc,XX+2*XX_GAP,YY+A*YY_GAP,offset show_grade[12*C+3],3
            invoke TextOut,hdc,XX+3*XX_GAP,YY+A*YY_GAP,offset show_grade[12*C+6],3
            invoke TextOut,hdc,XX+4*XX_GAP,YY+A*YY_GAP,offset show_grade[12*C+9],3
            invoke TextOut,hdc,XX+5*XX_GAP,YY+A*YY_GAP,offset buf[B*15].grade,1
            ENDM

             
            pop ebp
             invoke GetDC,hWnd
             mov    hdc,eax
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_name,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_chinese,7
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_math,4
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_english,7
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_average,7
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_grade,5
             
            ;  invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[0*15].myname,10
            ;  invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset show_grade[,3
            ;  invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset show_grade[3],3
            ;  invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset show_grade[6],3
            ;  invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset show_grade[9],3
            ;  invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[0*15].grade,1
	      LIST %1,%0,%0
            LIST %2,%1,%1
            LIST %3,%2,%2
            LIST %4,%3,%3
            LIST %5,%4,%4
			 ;cmp ebx,5
			 ;jne show
             ret
Display      endp
AvgRnk      proc near stdcall uses edx eax ecx ebx 
     
      MOV CX,0
      MOV DX,0
      MOV ebx,0

avg:  MOV esi,10
      MOV DL,byte ptr buf[ebx][esi]
      MOV DH,0
      ADD DX,DX
      MOV AX,0
      MOV AL,BYTE PTR buf[ebx][esi+1]
      MOV AH,0
      ADD DX,AX
      MOV AX,0
      MOV AL,BYTE PTR buf[ebx][esi+2]
      MOV AH,0
      SHR AX,1
      ADD DX,AX
      MOV AX,DX
      SHL AX,1
      DIV fac7
      MOV BYTE PTR buf[ebx][esi+3],AL
      add ebx,15
      CMP ebx,75
      JNE avg
	  

      MOV CX,0
      MOV BX,0
FUN4: CMP CX,5
	  JE RETURN
      MOV AL,BYTE PTR buf[BX][13]
      CMP al,90
      JAE SH_A
      CMP AL,80
      JAE SH_B
      CMP AL,70
      JAE SH_C
      CMP AL,60
      JAE SH_D
      mov byte ptr buf[BX][14],46H
      INC CX
	  ADD BX,15
      JMP FUN4

SH_A: MOV byte ptr buf[BX][14],41H
      INC CX
	  ADD BX,15
      JMP FUN4

SH_B: MOV byte ptr buf[BX][14],42H
      INC CX
	  ADD BX,15

      JMP FUN4

SH_C: MOV byte ptr buf[BX][14],43H
      INC CX
	  ADD BX,15

      JMP FUN4

SH_D: MOV byte ptr buf[BX][14],44H
      INC CX
	  ADD BX,15
      JMP FUN4


RETURN:    ret
AvgRnk    endp


             
shiftg proc near stdcall
.IF al==100
mov ah,0
mov al,101
.ELSE
mov ah,0
div fac10
xchg al,ah
add al,30h
add ah,30h
.ENDIF
ret
shiftg    endp

end  Start



