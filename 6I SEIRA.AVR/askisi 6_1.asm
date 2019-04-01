;;;;;AVR(1/4) exercise1;;;;;;

 .include "m16def.inc"
 .def leds = r23
 .def direction = r22

init: 
	ldi r24 , low(RAMEND) ; initialize stack pointer
	out SPL , r24
	ldi r24 , high(RAMEND)
	out SPH , r24
	clr r24				;me clear gia input
	out DDRB , r24   ; initialize PORTB for input
	ser r24			;me set gia output
	out DDRA , r24  ; initialize PORTA for output
	ldi leds , 0x80   
	ser direction
main:
	ldi r25 , 0x01
	ldi r24 , 0xf4
	out PORTA , leds
	rcall wait_msec
	sbic PINB , 0			;tsekaro input gia na stamatiso ti diadikasia
	rjmp main
	cpi direction,0x00		;dir=1 deksia dir=0 aristera
	breq left
right:
	lsr leds
	rjmp check
left:
	lsl leds
check:
	sbrc leds, 0		;an to teleutaio bit einai 1 direction aristera
	clr direction
	sbrc leds,7			;an to proto bit einai 1 direction deksia
	ser direction
	rjmp main


wait_msec:
 push r24 ; 2 κύκλοι (0.250 μsec)
 push r25 ; 2 κύκλοι
 ldi r24 , low(998) ; φόρτωσε τον καταχ. r25:r24 με 998 (1 κύκλος - 0.125 μsec)
 ldi r25 , high(998) ; 1 κύκλος (0.125 μsec)
 rcall wait_usec ; 3 κύκλοι (0.375 μsec), προκαλεί συνολικά καθυστέρηση 998.375 μsec
 pop r25 ; 2 κύκλοι (0.250 μsec)
 pop r24 ; 2 κύκλοι
 sbiw r24 , 1 ; 2 κύκλοι
 brne wait_msec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
 ret ; 4 κύκλοι (0.500 μsec)

wait_usec:
 sbiw r24 ,1 ; 2 κύκλοι (0.250 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 nop ; 1 κύκλος (0.125 μsec)
 brne wait_usec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
 ret ; 4 κύκλοι (0.500 μsec) 

