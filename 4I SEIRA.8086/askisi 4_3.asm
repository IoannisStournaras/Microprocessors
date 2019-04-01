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
ENDM

data segment
	MSG DB 0AH,0DH,'GIVE UP TO 16 CHARACTERS: $'
	INPUT DB 16 DUP(?)
	NEW_LINE DB 0AH,0DH, '$'
ENDS

code segment
start:
ASSUME CS:code,DS:data
MAIN PROC FAR
	MOV AX,data
	MOV DS,AX
ARXI:
	PRINT_STR MSG
    MOV CX,10H       ;deixnei poses fores tha ektelestei to loop
INIT:                ;arxikopoiisi tou pinaka mou
	LEA DI,INPUT
	ADD DI,CX
	DEC DI
	MOV AL,00H       ;arxikopoiisi theseon mnimis
	MOV [DI],AL
	LOOP INIT
	MOV CX,0
	MOV BX,0
	MOV DX,0
	LEA DI,INPUT

READ_NEXT:
	READ
	CMP AL,0DH      ;an patithei enter feugei
	JE RESULT
	CMP AL,'*'      ;an patithei * termatizei
	JE QUIT 
	CMP AL,20H      ;diavazo keno
	JE SAVE
	CMP AL,30H      ;diavazo grammata
	JL READ_NEXT
	CMP AL,39H
	JLE SAVE_DIG
	CMP AL,41H      ;diavazo kefalaia
	JL READ_NEXT
	CMP AL,5AH
	JLE SAVE
	CMP AL,61H      ;diavazo mikra
	JL READ_NEXT
	CMP AL,7AH
	JG READ_NEXT  
SAVE:	       ;apothikeuo tous xaraktires
	PRINT AL
	MOV [DI],AL
	INC DI
	INC BL     ;metritis xaraktiron
	CMP BL,16
	JL READ_NEXT
	JMP WAIT1
SAVE_DIG:     
	PRINT AL
	MOV [DI],AL
	INC DI
	CMP BH,0  ;deixnei tous protous 2 arithmous
	JE MOVE
	CMP BH,1
	JE MOVE2
	JMP FIGE
MOVE:         ;o CX xrisimeuei gia tin apothikeusi ton
	MOV CH,AL ;arithmon me skopo na emfaniso tous 2 mikroterous
	
MOVE2:
	MOV CL,AL 
	PUSH CX
FIGE:
	INC BL    ;metritis xaraktiron(koinos)
	INC BH
	CMP BL,16
	JL READ_NEXT
	
	
WAIT1:           ;an exo ftasei 16char perimeno enter i *
	READ
	CMP AL,0DH
	JE RESULT
	CMP AL,'*'
	JE QUIT
	JMP WAIT1
	
RESULT:
    CMP BL,0
    JE ARXI
	PRINT_STR NEW_LINE 
	LEA DI,INPUT
	PUSH BX      ;sozo kathe fora ton BX sti stoiva gia 
UPPERCASE:       ;na min xaso to plithos ton xaraktiron
    CMP BL,0     ;loopa tiposis kefalaion
    JE ADDR1
    DEC BL
	MOV DL,[DI]
	INC DI
	CMP DL,41H
	JL UPPERCASE
	CMP DL,5AH
	JG UPPERCASE
	PRINT DL
	JMP UPPERCASE
	
ADDR1:
	POP BX
	PRINT '-'
	LEA DI,INPUT
	PUSH BX
LOWERCASE:    ;loopa tiposis mikron
    CMP BL,0
    JE ADDR2
    DEC BL
	MOV DL,[DI]
	INC DI
	CMP DL,61H
	JL LOWERCASE
	CMP DL,7AH
	JG LOWERCASE
	PRINT DL
	JMP LOWERCASE
ADDR2:
	POP BX
	PRINT '-'
	LEA DI,INPUT
	POP CX
	MOV BH,0
NUM:           ;loopa tiposis arithmon
    CMP BL,0
    JE TELOS
    DEC BL
	MOV DL,[DI]
	INC DI
	CMP DL,30H
	JL NUM
	CMP DL,39H
	JG NUM
	INC BH
	PRINT DL 
	CMP BH,2
	JLE NUM 
	;SIGRISI
	CMP CL,DL   ;tsekaro an CL<DL
	JLE CHECK    ;an isxuei
	CMP CH,CL
    JLE CHECK2 
    MOV CH,CL   ;allios DL->CL->CH
	MOV CL,DL
	JMP NUM
CHECK:
	CMP CH,DL   ;tsekaro an CH<DL
	JLE NUM     ;an isxuei kamia metavoli
	CMP CL,DL   ;an oxi tsekaro an CL=DL
	JE NUM      ;an isxuei checkaro epomeno arithmo
	MOV CH,CL   ;allios DL->CL->CH
	MOV CL,DL
	JMP NUM
CHECK2:
	MOV CL,DL
	JMP NUM

TELOS:
	PRINT_STR NEW_LINE
	PRINT CH    ;sto CH apothikeuo to 1o noumero
	PRINT CL    ;sto CL apothikeuo to 2o noumero kata seira
	PRINT_STR NEW_LINE
	JMP ARXI	

QUIT:
	EXIT
MAIN ENDP

code ENDS
END MAIN

	
