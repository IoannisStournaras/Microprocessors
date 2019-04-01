.include "m16def.inc"

.def temp=r19
.def temp1=r20
.def temp2=r21
.def temp3=r23
.def temp4=r24

rjmp reset
	
reset:
	ldi temp4, high(RAMEND)
	out SPH, temp
	ldi temp4, low(RAMEND)
	out SPL, temp
	
	ldi temp4, 0x0F				;Αρχικοποίηση PORTC για έξοδο
	out DDRC, temp
	clr temp4					;Αρχικοποίηση PORTA για είσοδο
	out DDRA, temp				;Αρχικοποίηση PORTB για είσοδο
	out DDRB, temp
	
gate_1:
	in temp1, PINB
	mov temp2, temp1
	andi temp1, $01
	andi temp2, $02
	lsr temp2
	or temp2, temp1
	mov temp,temp2
	
gate_2:
	in temp1, PINB
	mov temp2, temp1
	andi temp1, $04
	andi temp2, $08
	lsr temp2
	and temp2, temp1
	lsr temp2
	andi temp2, $02
	or temp, temp2
	
gate_3:
	in temp1, PINB
	mov temp2, temp1
	andi temp1, $10
	andi temp2, $20
	lsr temp2
	eor temp2, temp1
	lsr temp2
	lsr temp2
	andi temp2, $04
	or temp, temp2
	mov temp3, temp2
	lsl temp3
	andi temp3, $08
	
gate_4:
	in temp1, PINB
	mov temp2, temp1
	andi temp1, $40
	andi temp2, $80
	lsr temp2
	eor temp2, temp1
	lsr temp2
	lsr temp2
	lsr temp2
	andi temp2, $08
	
gate_5:
	eor temp2, temp3
	andi temp2, $08 
	or temp, temp2

read_PORTA:
	clr temp3
	in temp4, PINA
	sbrc temp4,0
	sbr temp3,0
	sbrc temp4,1
	sbr temp3,1
	sbrc temp4,2
	sbr temp3,2
	sbrc temp4,3
	sbr temp3,3
	eor temp,temp3
	out PORTC,temp
	rjmp reset
