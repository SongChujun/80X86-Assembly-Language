	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	V 300h
	?debug	S "cinput.c"
	?debug	C E984B07E4A0863696E7075742E63
	?debug	C E94019CA181B433A5C424F524C414E44435C494E434C5544455C73+
	?debug	C 7464696F2E68
	?debug	C E94019CA181B433A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 646566732E68
	?debug	C E94019CA181C433A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 6E66696C652E68
	?debug	C E94019CA181B433A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 6E756C6C2E68
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	int main()
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
	sub	sp,16
   ;	
   ;	{
   ;	
   ;		char name[15];
   ;		scanf("%s", name);
   ;	
	lea	ax,word ptr [bp-16]
	push	ax
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
   ;	
   ;		printf("%s", name);
   ;	
	lea	ax,word ptr [bp-16]
	push	ax
	mov	ax,offset DGROUP:s@+3
	push	ax
	call	near ptr _printf
	pop	cx
	pop	cx
   ;	
   ;	    return 0;
   ;	
	xor	ax,ax
	jmp	short @1@58
@1@58:
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
_main	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'%s'
	db	0
	db	'%s'
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
	extrn	_scanf:near
	extrn	_printf:near
_s@	equ	s@
	end
