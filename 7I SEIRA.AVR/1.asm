;;;;;;;;AVR(2/4) exersize1;;;;;;;;;;;;;
.include "m16def.inc"
.org 0x0
rjmp reset
.org 0x2
rjmp ISR0

reset:
ldi r24, low(RAMEND)
out SPL, r24
ldi r24, high(RAMEND)
out SPH, r24
ldi r24, (1<<ISC01)|(1<<ISC00)
out MCUCR, r24
ldi r24, (1<<INT0)
out GICR, r24
sei
ser r26
out DDRA, r26
out DDRB, r26
clr r26
clr r23

loop:
out PORTA, r26
out PORTB, r23
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

ISR0:
push r26
in r26, SREG
push r26
check:
ldi r24 ,(1 << INTF0)
out GIFR ,r24 ; μηδένισε το bit 6 του GIFR
ldi r24, low(5)
ldi r25, high(5)
rcall wait_msec
in r26, GIFR
sbrc r26,6
rjmp check
sbic PIND,0
inc r23
pop r26
out SREG, r26
pop r26
reti