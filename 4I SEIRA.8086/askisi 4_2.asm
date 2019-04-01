PRINT MACRO CHAR	
	PUSH DX
	PUSH AX
	MOV DL,CHAR
	MOV AH,02H
	INT 21H
	POP AX
	POP DX
ENDM

PRINT_STR MACRO STRING	
	PUSH DX
	PUSH AX
	MOV DX,OFFSET STRING
	MOV AH,09H
	INT 21H
	POP AX
	POP DX
ENDM

READ MACRO
	MOV AH,08H
	INT 21H
ENDM

EXIT MACRO
	MOV AH,4CH
	INT 21H
ENDM

data segment			;orismos minimaton
	NEW_LINE DB 0AH,0DH,'$'
	MSG_1 DW 'GIVE 3 HEX DIGITS: $'
	MSG_2 DW 'DEMICAL= $'
ends

code segment
start:
ASSUME CS:code,DS:data
MAIN PROC FAR
	MOV AX,data
	MOV DS,AX

arxi:
	PRINT_STR MSG_1	
	MOV BX,0	;arxikopoiisi metriti HEX psifion
	MOV DX,0	;arxikopoiisi kataxoriton pou tha periexoun ton arithmo mas
	MOV CL,4	;kathorizei to plithos ton shift left
ADDR1:
	CALL HEX_KEYB
	CMP AL,'U'
	JE QUIT
	SHL DX,CL	;metatopizo kathe fora 4 fores gia na metatrepso ton HEX se DEM
	ADD DL,AL	
	INC BX		;auksano metriti psifion
	CMP BX,3
	JL ADDR1
WAIT_ENTER:		;dn kanei tpt mexri na patithei enter
	READ
	CMP AL,'U'	;kanei exit an patithei U
	JE QUIT
	CMP AL,0DH
	JE CONT
	JMP WAIT_ENTER

CONT:
	PRINT_STR NEW_LINE
	PRINT_STR MSG_2
	MOV CX,0	;Arxikopoiisi metriti gia tipoma
	MOV AX,DX	;vazo ton arithmo ston AX gia ti diairesi
ADDR2:
	MOV DX,0	
	MOV BX,10	;diairo kathe fora me 10 gia na kathoriso monades,dekades klp
	DIV BX
	PUSH DX		;sozo kathe fora to ipoloipo sti stoiva gia tipoma
	INC CX		;to CX kathorizei an tha exo xiliades,ekatontades klp
	CMP AX,0
	JNE ADDR2
	CMP CX,4	;an exo xiliades tipono kai to koma
	JNE ADDR3
	POP DX
	ADD DX,30H
	PRINT DL
	PRINT ','
	DEC CX
ADDR3:			;allios tipono apla ton arithmo
	POP DX
	ADD DX,30H
	PRINT DL
	LOOP ADDR3
	PRINT_STR NEW_LINE
	JMP START
QUIT:
	EXIT
MAIN ENDP

HEX_KEYB PROC NEAR	;routina anagnosis kai metatropis HEX se dec
	PUSH DX
IGNORE:
	READ
	CMP AL,'U'
	JE EXIT_LOOP
	CMP AL,30H		;tsekaro an einai arithmos 0-9
	JL IGNORE
	CMP AL,39H
	JG GRAMMA
	PUSH AX
	PRINT AL
	POP AX
	SUB AL,30H
	JMP EXIT_LOOP
GRAMMA:				;tsekaro an einai gramma A-F
	CMP AL,'A'
	JL IGNORE
	CMP AL,'F'
	JG MIKRO
	PUSH AX
	PRINT AL
	POP AX
	SUB AL,37H
	JMP EXIT_LOOP
MIKRO:				;trekaro an einai gramma a-f
	CMP AL,'a'
	JL IGNORE
	CMP AL,'f'
	JG IGNORE
	SUB AL,20H
	PUSH AX
	PRINT AL		;metatrepo se kefalaio kai tipono
	POP AX
	SUB AL,37H
EXIT_LOOP:
	POP DX
	RET
	
HEX_KEYB ENDP

code ENDS
END MAIN