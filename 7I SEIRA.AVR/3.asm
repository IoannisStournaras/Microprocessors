;;;;;;;;AVR(2/4) exersize3;;;;;;;;;;;;;
.include "m16def.inc"
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
	ldi temp ,(1<<TOIE1) ; ενεργοποίηση διακοπής υπερχείλισης του μετρητή TCNT1
	out TIMSK ,temp ; για τον timer1
	ldi temp ,(1<<CS12) | (0<<CS11) | (1<<CS10) ; CK/1024
	out TCCR1B ,temp 
	
main:
	sbis PINB,0
	rjmp main
	ldi r24,0xA4; αρχικοποίηση του TCNT1 to
	out TCNT1H ,r24 ; για υπερχείλιση μετά από 3 sec
	ldi r24 ,0x73
	out TCNT1L ,r24
	ldi leds,0x80
	out PORTA, leds
	rjmp main

ISR0:
	ldi r24,0xA4; αρχικοποίηση του TCNT1 to
	out TCNT1H ,r24 ; για υπερχείλιση μετά από 3 sec
	ldi r24 ,0x73
	out TCNT1L ,r24
	ldi leds,0x80
	out PORTA, leds
	reti

ISR_TIMER1_OVF:
	clr leds
	out PORTA, leds
	reti
