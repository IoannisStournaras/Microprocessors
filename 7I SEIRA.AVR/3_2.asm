;;;;;;;;AVR(2/4) exersize3;;;;;;;;;;;;;
.include "m16def.inc"
.def flag=r27
.def leds=r25
.def temp=r24
.org 0x0
rjmp reset
.org 0x2
rjmp ISR0
.org 0x10
rjmp ISR_TIMER1_OVF ; ρουτίνα εξυπηρέτησης της διακοπής υπερχείλισης του timer1

reset:
	ldi temp, low(RAMEND)
	out SPL, temp
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, (1<<ISC01)|(1<<ISC00)
	out MCUCR, temp
	ldi temp, (1<<INT0)
	out GICR, temp
	ldi temp, 0b11111110
	out DDRB, temp ; port B input
	ser temp
	out DDRA,temp
	sei
	ldi temp ,(1<<CS12) | (0<<CS11) | (1<<CS10) ; CK/1024
	out TCCR1B ,temp 
	clr flag
	
main:
	cpi flag,0x01		;me flag 0 metrao 0.5sec
	breq cont			;otan flag=1 exo metrisei 0.5sec kai ksekinao na metrao 2.5
	sbis PINB,0
	rjmp main
	clr flag
	ldi temp ,(1<<TOIE1) ; ενεργοποίηση διακοπής υπερχείλισης του μετρητή TCNT1
	out TIMSK ,temp ; για τον timer1
	ldi r24,0xF0		;ρχικοποίηση του TCNT1 to
	out TCNT1H,r24		;για υπερχείλιση μετά από 0.5 sec
	ldi r24,0xBE
	out TCNT1L,r24
	ldi leds,0xFF
	out PORTA,leds
	cpi flag,0x01
	brne main
cont:
	ldi flag,0x02		;gia na apofigo tin arxikopoiisi tou timer sinexos theto flag=2 otan perimeno ta 2.5
	ldi r24,0x76		; αρχικοποίηση του TCNT1 to
	out TCNT1H ,r24 	; για υπερχείλιση μετά από 4.5 sec
	ldi r24 ,0xAC
	out TCNT1L ,r24
	ldi leds,0x80
	out PORTA, leds
	rjmp main

ISR0:
	ldi temp ,(1<<TOIE1) ; ενεργοποίηση διακοπής υπερχείλισης του μετρητή TCNT1
	out TIMSK ,temp ; για τον timer1
	ldi flag,0x00
	ldi r24,0xF0		; αρχικοποίηση του TCNT1 to
	out TCNT1H ,r24 	; για υπερχείλιση μετά από 0.5 sec
	ldi r24 ,0xBE
	out TCNT1L ,r24
	ldi leds,0xFF
	out PORTA, leds
	reti

ISR_TIMER1_OVF:
	cpi flag,0x02	
	breq led_off
	ldi flag,0x01
	ldi leds,0x80
	rjmp telos
led_off:
	ldi temp ,(0<<TOIE1) ; ενεργοποίηση διακοπής υπερχείλισης του μετρητή TCNT1
	out TIMSK ,temp ; για τον timer1
	ldi flag,0x00		
	clr leds
telos:	
	out PORTA, leds
	reti
