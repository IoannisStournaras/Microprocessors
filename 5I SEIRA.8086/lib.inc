PRINT_STR MACRO STRING
	PUSH DX
	PUSH AX
	MOV DX,OFFSET STRING
	MOV AH,09H
	INT 21H
	POP AX
	POP DX
ENDM

EXIT MACRO
	MOV AH,4CH
	INT 21H
ENDM

PRINT MACRO CHAR
	PUSH DX
	PUSH AX
	MOV DL,CHAR
	MOV AH,02H
	INT 21H
	POP AX
	POP DX
ENDM

READ MACRO
	MOV AH,08H
	INT 21H
	MOV AH,0
ENDM  

DEFINE_READ_DEC MACRO			;DIADIKASIA ANAGNOSIS APTO PLIKTROLOGIO
LOCAL READ_NEXT,FIRST,IGNORE,COUNT,WAIT,EXIT2,EXIT1

READ_DEC PROC NEAR
	PUSH BX
	MOV [DI+1],DH		;telestes gia eksodo apo routina 
	MOV [DI+2],DL
    MOV CX,0
	MOV BX,0
	MOV [DI],BL
	MOV [DI+3],BL
	MOV DX,0
READ_NEXT:
	MOV AX,CX		;pollaplasiasmos arxikou arithmou me 10
	MOV BX,10
	MUL BX
	MOV CX,AX		;metafora arithmou ston CX
	CMP DX,0
	JE IGNORE		;an exo iperxeilisi theto 1 ton DX
	MOV DX,1
IGNORE:
	READ			;anagnori arithmon 
	MOV [DI+3],AL
	CMP AL,[DI+1]
	JE EXIT2
	CMP AL,[DI+2]
	JE EXIT2
	CMP AL,30H
	JL IGNORE
	CMP AL,39H
	JG IGNORE
	PRINT AL		;dimiourgeia duadikou apo ASCII
	SUB AL,30H
	ADD CX,AX		;prostheto ton kainourgio arithmo pou diavasa 
	JNB COUNT		;ston proigoumeno*10 
	MOV DX,1		;an exo kratoumeno theto 1 ton DX
COUNT:
	MOV BL,[DI]
	INC BL			;metrao max 5 epanalipseis
	MOV [DI],BL
	CMP BL,5
	JE WAIT
	JMP READ_NEXT
WAIT:	
	READ 			;allios perimeno ton katallilo telesti
	CMP AL,[DI+1]
	JE EXIT1
	CMP AL,[DI+2]
	JE EXIT1
	JMP WAIT
EXIT2:
	MOV AX,CX		;an kano eksodo me ligoteres epanalipseis 
	MOV BX,10		;diairo me 10 kathos exo pollaplasiasei me 10 mia fora parapano
	DIV BX
	MOV CX,AX
	MOV AL,[DI+3]
EXIT1:
	MOV DH,AL
	PRINT AL
	POP BX
	RET
READ_DEC ENDP
DEFINE_READ_DEC ENDM	    

DEFINE_PRINT_DEC MACRO
LOCAL RESULT,ADDR3

PRINT_DEC PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
RESULT:         ;metatropi duadikou se dekadiko    
	MOV BX,10
	DIV BX
	INC CX
	PUSH DX
	MOV DX,0
	CMP AX,0
	JNE RESULT
ADDR3:			;tipoma tou arithmou pou exei prokipsei
	POP DX
	ADD DX,30H
	PRINT DL
	LOOP ADDR3
	POP DX
	POP CX
	POP BX
	POP AX
	RET
PRINT_DEC ENDP
DEFINE_PRINT_DEC ENDM

DEFINE_PRINT_HEX MACRO
LOCAL START,GRAM,EDO,PRINT1

PRINT_HEX PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV CH,4		metatropi duadikou se 16
	MOV CL,4
	MOV BX,AX
	CMP DL,0
	JZ START
	ADD DL,30H
	PRINT DL
START:
	AND AL,0FH
	CMP AL,9
	JG	GRAM
	ADD AL,30H
	MOV [DI],AL
	INC DI
	JMP EDO
GRAM:
	ADD AL,37H
	MOV [DI],AL
	INC DI
EDO:
	DEC CH
	SHR BX,4
	MOV AX,BX
	CMP CH,0
	JNE START
PRINT1:
	MOV AL,[DI-1]
	PRINT AL
	DEC DI
	LOOP PRINT1
	POP DX
	POP CX
	POP BX
	POP AX
	RET
PRINT_HEX ENDP
DEFINE_PRINT_HEX ENDM
	


	