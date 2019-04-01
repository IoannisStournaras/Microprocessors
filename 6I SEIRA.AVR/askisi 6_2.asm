
.include "m16def.inc"
.def on_del = r22  
.def off_del = r23  
.def  leds = r21 
.def  temp = r20  
.def  input =r19  
init:
	ldi r24, low(RAMEND)
	ldi r25, high(RAMEND)
	out SPL, r24
	out SPH, r25
	clr temp	;me clear gia input
	out DDRB , temp
	ser temp	;me set gia output
	out DDRA ,temp

main:
	in input , PINB		;eisodos gia xronokathisterisi
	cmp input,0x00		;an einai 0 panta svista
	breq p_off
	mov temp , input	
	andi temp,0x0F		;kathisterisi tou ON
	cmp temp,0x00
	breq p_off			;an einai 0 panta svista
	mov on_del,temp
	swap input
	andi input,0x0F		;kathisterisi tou OFF
	mov off_del , input
	ldi temp , 0x64
flash:
	rcall on
	cmp off_del,0x00	;an einai 0 i kathisterisi tou OFF panta anoixta
	breq main
	mul on_del , temp	;dimourgo kathisterisi 100*x
	mov r25,r1
	mov r24,r0
	rcall wait_msec
	rcall off
	mul off_del , temp	;apotelesma MUL stous r1/r0
	mov r25,r1
	mov r24,r0
	rcall wait_msec
	rjmp main
p_off:
	rcall off
	rjmp main
on: 
	ser leds
	out PORTA , leds
	ret
off:
	clr leds
	out PORTA , leds
	ret

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
