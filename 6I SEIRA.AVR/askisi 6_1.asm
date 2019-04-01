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
 push r24 ; 2 ������ (0.250 �sec)
 push r25 ; 2 ������
 ldi r24 , low(998) ; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
 ldi r25 , high(998) ; 1 ������ (0.125 �sec)
 rcall wait_usec ; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
 pop r25 ; 2 ������ (0.250 �sec)
 pop r24 ; 2 ������
 sbiw r24 , 1 ; 2 ������
 brne wait_msec ; 1 � 2 ������ (0.125 � 0.250 �sec)
 ret ; 4 ������ (0.500 �sec)

wait_usec:
 sbiw r24 ,1 ; 2 ������ (0.250 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 brne wait_usec ; 1 � 2 ������ (0.125 � 0.250 �sec)
 ret ; 4 ������ (0.500 �sec) 

