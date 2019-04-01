include 'lib.inc'

data segment
    NEW_LINE DB 0DH,0AH, '$'
    OPER DB 4 (?)
	NUMBERS DB 8(?)  
	MSG DB "PRESS Q TO QUIT OR C TO CONTINUE: $"
ends


code segment
    ASSUME CS:code,DS:data
    DEFINE_READ_DEC
    DEFINE_PRINT_DEC 
    DEFINE_PRINT_HEX
    
MAIN PROC FAR                                       
    MOV AX,data
    MOV DS,AX   
    
start:
    LEA DI,OPER
    MOV DH,'+'		;theto tous telestes gia na kaleso tin sinartisi
    MOV DL,'-'  
    CALL READ_DEC 
	MOV BX,CX       ;BX 1os arithmos
	PUSH DX			;DX iperxeilisi 1ou arithmou
	MOV DH,0
	MOV DL,'='		;fortono to neo telesti
	LEA DI,OPER
	CALL READ_DEC	;epistrefei ston CX ton 2o arithmo
	MOV AX,DX      ;AX iperxilisi 2ou arithmou
	POP DX
	CMP DH,'+' 
	MOV DH,0
	MOV AH,0
	JNE MINUS
PLUS:
	ADD CX,BX       ;athroisma arithmon
	ADC DX,AX       ;athroisma uperxiliseon
	MOV AX,CX       ;Gia ti diairesi DX|AX
    MOV CX,0     
    LEA DI,OPER		;tipoma thetikon arithmon
    CALL PRINT_HEX  
    PRINT '='
    CALL PRINT_DEC
    PRINT_STR NEW_LINE 
    PRINT_STR MSG 
    JMP STOP
MINUS:
    SUB DX,AX		;afairesi iperxeiliseon
    JNB GREAT 
    NEG DX
GREAT:
    SUB BX,CX		;afairesi arithmon
	JNB TYPE
	PRINT '-'
	NEG BX 
TYPE:
	MOV CX,0
	MOV AX,BX     	; tipoma arnitikou arithmou
	LEA DI,OPER  
	CALL PRINT_HEX
	PRINT '='
	print '-'
    CALL PRINT_DEC
    PRINT_STR NEW_LINE 
    PRINT_STR MSG 
STOP:
    READ			
    CMP AL,'Q'
    JE TELOS 
    CMP AL,'C'
    JNE STOP  
    PRINT_STR NEW_LINE 
	JMP start  
	
TELOS:
    EXIT	
    
MAIN ENDP   
code ends

end MAIN 