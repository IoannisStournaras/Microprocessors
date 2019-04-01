.text
.global main

metatropi:
	stmfd sp!, {r1-r4, fp, lr}
	cmp r0,#48
	blo return
	cmp r0,#58
	blo digit
	cmp r0,#65
	blo return
	cmp r0,#91
	blo upper
	cmp r0,#97
	blo return
	cmp r0,#123
	bge return
lower:
	sub r0,r0,#32
	b return
upper:
	add r0,r0,#32
	b return
digit: 
	cmp r0,#53
	addlo r0,r0,#5
	subge r0,r0,#5
return:
	strb r0,[r1]
	ldmfd sp!, {r1-r4, fp, lr}
	bx lr

main:
start:
	mov r4,#0
	mov r0,#1	/* write system call*/
	ldr r1, =input_msg
	mov r2,#len
	mov r7,#4
	swi 0

	mov r0,#0	/*read system call*/
	ldr r1,=input_str
	mov r2, #32
	mov r7,#3
	swi 0
	mov r3,r0
	sub r0,r0,#1
	add r1,r1,r0
	ldrb r2,[r1]
	cmp r2,#10
	movne r4,#1
	beq continue

ignore:
	mov r0,#0	/*read system call*/
	ldr r1, =crap
	mov r2,#8
	mov r7,#3
	swi 0
	sub r0,r0,#1
	add r1,r1,r0
	ldrb r2,[r1]
	cmp r2,#10
	bne ignore

continue:
	ldr r1, =input_str /*r1 has the address of input string*/
	sub r1,r1,#1
	add r2,r3,r1 /*r2 has the address of the last char*/
	cmp r3,#2
	bne loopa
	ldrb r0,[r1,#1]
	cmp r0,#81
	beq exit
	cmp r0,#113
	beq exit

loopa:
	ldrb r0,[r1,#1]!
	bl metatropi
	cmp r1,r2
	bne loopa

	mov r0,#1
	ldr r1,=output_msg
	mov r2,#len2
	mov r7,#4
	swi 0
	mov r0,#1
	ldr r1,=input_str
	mov r2,r3
	mov r7,#4
	swi 0

	cmp r4,#0
	beq start
	mov r0,#1
	ldr r1,=newline
	mov r2,#1
	mov r7,#4
	swi 0
	b start

exit:
	mov r0,#0
	mov r7,#1
	swi 0

.data

	input_msg: .ascii "Please input a string up to 32 char long: " /* location of input msg in memory */

	len = . - input_msg /* length  is the current memory indicated by (.) minus the memory location of the first element of string. Len does not occupy memory. It is a constant for the assembler. */

	output_msg: .ascii "Result is: "
	len2 = . - output_msg

	input_str: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" /* pre-allocate 32 bytes for input string, initialize them with null character '/0'*/
	newline: .ascii "\n"
	crap: .ascii "crapcrap"
