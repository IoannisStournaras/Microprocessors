.include "m16def.inc"

.DSEG
_tmp_: .byte 2
.CSEG

.def leds = r21
.def counter = r20
.org 0x000

reset:
	ldi r26,low(RAMEND)
	out SPL,r26
	ldi r26,high(RAMEND)
	out SPH,r26
	ser r26
	out DDRB,r26
	ldi r24 ,(1 << PC7) | (1 << PC6) | (1 << PC5) | (1 << PC4) ;set 4 msb as output
	out DDRC,r24
	;initialize _temp_ to zero
	ldi r26,low(_tmp_) 
	ldi r27,high(_tmp_)
	clr r22
	st X+,r22
	st X,r22

read_first:
	clr leds
	out PORTB,leds
	ldi r24,0x14
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24,0
	breq read_first
	cpi r24,'1'
	brne read_first

read_second:
	ldi r24,0x14
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24,0
	breq read_first
	cpi r24,'8'
	brne read_second
	rcall leds_on
	rjmp read_first

	
scan_row: ; input row number (r24), output each button value 4 lsb of r24
	ldi r25, 0x08 ; initialize with 0000 1000
back_:
	lsl r25 ; shift left r24 times
	dec r24
	brne back_
	out PORTC, r25 ; set r25 row to 1
	nop
	nop ; delay in order to change state
	in r24,PINC ; get pressed buttons' columns
	andi r24, 0x0f ; isolate 4 lsb
	ret

scan_keypad:
	ldi r24,0x01
	rcall scan_row
	swap r24
	mov r27,r24
	ldi r24,0x02
	rcall scan_row
	add r27,r24
	ldi r24,0x03
	rcall scan_row
	swap r24
	mov r26,r24
	ldi r24,0x04
	rcall scan_row
	add r26,r24
	movw r24,r26
	ret

scan_keypad_rising_edge:
	mov r22,r24 ; save time to r22
	rcall scan_keypad ; check keypad for pressed buttons
	push r24
	push r25
	mov r24,r22 ; r22 ms delay
	ldi r25,0
	rcall wait_msec
	rcall scan_keypad ; check keypad again
	pop r23
	pop r22
	and r24,r22
	and r25,r23
	ldi r26,low(_tmp_) ; load buttons state
	ldi r27,high(_tmp_) ; from ram
	ld r23, X+
	ld r22, X
	st X, r24
	st -X,r25
	com r23
	com r22
	and r24,r22
	and r25,r23
	ret

keypad_to_ascii:
	movw r26,r24
	ldi r24,'*'
	sbrc r26,0
	ret
	ldi r24,'0'
	sbrc r26,1
	ret
	ldi r24,'#'
	sbrc r26,2
	ret
	ldi r24,'D'
	sbrc r26,3
	ret
	ldi r24,'7'
	sbrc r26,4
	ret
	ldi r24,'8'
	sbrc r26,5
	ret
	ldi r24,'9'
	sbrc r26,6
	ret
	ldi r24,'C'
	sbrc r26,7
	ret
	ldi r24,'4'
	sbrc r27,0
	ret
	ldi r24,'5'
	sbrc r27,1
	ret
	ldi r24,'6'
	sbrc r27,2
	ret
	ldi r24,'B'
	sbrc r27,3
	ret
	ldi r24,'1'
	sbrc r27,4
	ret
	ldi r24,'2'
	sbrc r27,5
	ret
	ldi r24,'3'
	sbrc r27,6
	ret
	ldi r24,'A'
	sbrc r27,7
	ret
	clr r24
	ret

wait_usec:
	sbiw r24,1
	nop
	nop
	nop
	nop
	brne wait_usec
	ret

wait_msec:
	push r24
	push r25
	ldi r24, low(998)
	ldi r25, high(998)
	rcall wait_usec
	pop r25
	pop r24
	sbiw r24,1
	brne wait_msec
	ret

leds_on:
	ldi counter, 0x14
loopaki:
	com leds
	out PORTB,leds
	ldi r24,low(250)
	ldi r25,high(250)
	rcall wait_msec
	dec counter
	cpi counter,0
	brne loopaki
	ret

