.include "m16def.inc"
.org 0x0
rjmp reset
.org 0x4
rjmp ISR1

reset:
ldi r24, low(RAMEND)
out SPL, r24
ldi r24, high(RAMEND)
out SPH, r24
ldi r24, (1<<ISC11)|(1<<ISC10)
out MCUCR, r24
ldi r24, (1<<INT1)
out GICR, r24
sei
clr r26 
out DDRB, r26
ser r26
out DDRA, r26
out DDRC, r26
clr r26 ;μηδενισμός μετρητή
clr r23 ;μηδενισμός μετρητή 

loop:
out PORTA, r26
out PORTC, r23
ldi r24, low(100)
ldi r25, high(100)
rcall wait_msec
inc r26
rjmp loop

wait_msec:
push r24
push r25
ldi r24, low(998)
ldi r25, high(998)
rcall wait_usec
pop r25
pop r24
sbiw r24, 1
brne wait_msec
ret

wait_usec:
sbiw r24, 1
nop
nop
nop
nop
brne wait_usec
ret


ISR1:
push r26
in r26, SREG
push r26

check1:
	ldi r24 ,(1 << INTF1)
	out GIFR ,r24 ; μηδένισε το bit 7 του GIFR
	ldi r24, low(5)
	ldi r25, high(5)
	rcall wait_msec
	in r22, GIFR
	sbrc r22,7
	rjmp check1
	clr r23
	ldi r22,0x08
	in r26, PINB
count:
	sbrc r26, 0
	inc r23
	lsr r26
	dec r22
	cpi r22,0x00
	brne count
pop r26
out SREG, r26
pop r26
reti
	