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

FRACT MACRO CHAR      ;Macro pou xrisimopoieitai gia ton 
	PUSH DX           ;upologismo tou dekadikou merous
	MOV DH,CHAR
	AND DH,03H        
	CMP DH,03H
	JNE KATO
	MOV AH,37H        ;11-> 0.75
	MOV AL,35H        
	JMP TELOS1
KATO:
	CMP DH,02H        ;10->0.5
	JNE KATO1
	MOV AH,35H
	MOV AL,30H
	JMP TELOS1
KATO1:
	CMP DH,01H        ;01->0.25
	JNE KATO2:
	MOV AH,32H
	MOV AL,35H
	JMP TELOS1
KATO2:
	MOV AH,30H        ;00->0.00
	MOV AL,30H
TELOS1:
	POP DX
ENDM
	
CHECK MACRO           ;routina elegxou allilouxias termatismou
    PUSH AX
	CMP AL,'B'
	JNE ERROR
	READ
	CMP AL,31H
	JNE ERROR
	READ 
	CMP AL,38H
	JNE ERROR
	EXIT
ERROR:     
    POP AX
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
	MSG DB 'Give a 9-bit number: $'
	MSG_2 DB 'DECIMAL: $'
	NEW_LINE DB 0AH,0DH, '$'
ENDS

code segment
ASSUME CS:code,DS:data
start:
MAIN PROC FAR
	MOV AX,data
	MOV	DS,AX
arxi:
	PRINT_STR MSG
	MOV BX,0
	MOV DX,0
	MOV CX,7
	
READ_NEXT:       ;Loop upologismou akeraiou merous
    READ
	CHECK  
	CMP AL,30H
	JL READ_NEXT
	CMP AL,31H
	JG READ_NEXT
	PRINT AL
	SUB AL,30H   ;metatropi apo ascii se arithmo
	SHL BL,1     ;dimiourgeia BIN me olisthisi 
	ADD BL,AL
	LOOP READ_NEXT
	MOV CX,2
	PRINT '.'
FRACTION:        ;loop katagrafis dekadikou merous
	READ     
	;CHECK 
	CMP AL,30H
	JL FRACTION
	CMP AL,31H
	JG FRACTION
	PRINT AL
	SUB AL,30H
	SHL DL,1
	ADD DL,AL
	LOOP FRACTION
	PRINT_STR NEW_LINE
	PRINT_STR MSG_2
	MOV CX,0
	MOV DH,BL
	TEST DH,40H ;elegxos an to msb einai 0
	JZ POS      ;an nai thetikos kai tipono apotelesma
    AND DH,63   ;an oxi metatropi arithmou se 2s component
    SHL DH,2
    ADD DH,DL
    NEG DH
    MOV DL,DH
    AND DL,03H
    AND DH,252
    SHR DH,2    ;arithmos katallilos gia upologismo arithmou
	PRINT '-'
	JMP RESULT
POS:
	PRINT '+'	
RESULT:         ;metatropi duadikou se dekadiko
	MOV AX,0    ;morfi katallili gia tipoma
	MOV AL,DH
	MOV BL,10
	DIV BL
	INC CX
	MOV DH,AL
	PUSH AX
	CMP AL,0
	JNE RESULT
ADDR3:			;tipoma tou arithmou pou exei prokipsei
	POP AX
	ADD AH,30H
	PRINT AH
	LOOP ADDR3
	FRACT DL    ;ypologismos dekadikou merous
	PRINT '.'
	PRINT AH    ;tipoma dekadikou merous
	PRINT AL
	PRINT_STR NEW_LINE
	JMP ARXI
MAIN ENDP
code ends
END MAIN
