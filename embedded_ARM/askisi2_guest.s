.text
.global main
.extern malloc

main:		
	mov r0, #64	/* allocate */
	bl malloc

	mov r8,r0	/* store the address of the beginning of the string in r8 */

    mov r0, #128    /* allocate the bytes needed for the frequency table  with malloc */
	bl malloc

    mov r9,r0	/* store the address of the first element of the table in r9 */

	ldr r0, =filename	/* perform the open system call with O_RDWR rights */
	mov r1, #2	
	mov r7, #5
	swi 0
	
	push {r0}	/* store the file descriptor in the stack */ 
	mov r6,r0	

	mov r1, r8 	/* perform the read system call */
	mov r2, #64	
	mov r7, #3
	swi 0
	
	mov r2, r0	
	
	push {r2}	/* store the length of the string returned by read in the stack */
	
	
frequencies:

	mov r3, #0	/* initialize register of frequencies*/
	pop {r2}	/* pop lenght in order to check all the characters */

check_max:

	ldrb r0, [r8], #1 /* load the current character of the string */
	cmp r0,#32	/* check if space character */
	beq continue
	mov r5, r0	/* store the current character */
	ldr r1, [r9, r0,lsl #2] /* counter[i]=counter[i]+1 */
	add r1, r1, #1
	str r1, [r9, r0,lsl #2]
	cmp r1, r3	/* compare current frequencie with max */
	bllt continue 	/* if less check next character */
	bleq equal	/* if  equal check min ascii code */
	mov r3, r1	/* if greater store store current char */
	mov r4, r5	

equal:

	cmp r4, r5	
	movgt r4, r5	

continue:

	sub r2, r2, #1	/* decrease length counter */
	cmp r2, #0	/* if equal zero send results to host */
	bleq send_results
	bl check_max 	/* else check next char */


send_results:
	
	strb r4, [r9]	/* store letter and frequency */
	strb r3, [r9,#1]

    ldr r0,=output
    ldr r1,=output_format
    ldrb r2,[r9]
    ldrb r3,[r9,#1]
    bl sprintf /*create string to send to host*/
    ldr r0,=output
    bl puts /*print string and send it to host*/

	ldr r6,=output /*load output address*/
	mov r0,r6
	bl strlen	/*calculate string length*/
	mov r2,r0	/*r2=length*/
	pop {r0}	/*pop file descriptor from stack*/
	mov r1,r6	/*r1=addrss output*/
	mov r7,#4
	swi 0		/*write system call*/
		cmp r0,#0 
		beq Err
		cmp r2,r0
		bne Err2 /*check errors in  write system call*/		
	bl finish
	Err:
		ldr r0,=error
		bl perror
	bl finish

	Err2:
		ldr r0,=error2
		bl perror       
	

finish:
			
	mov r0, #0	/* perform the exit system call with return value 0 */
	mov r7,#1
	swi 0

.data
	port: .asciz "/dev/ttyAMA0"
	output_format:
                .asciz "The most frequent character is \"%c\" and it appears %d time(s)\n\0"
        output:
                .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
                .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	error: .ascii "Error: couldn't write all characters\000"
        error2: .ascii "Error: nothing writen\000"

	options:	.word 0x00000000 /*c_iflag*/	
			.word 0x00000000 /*c_oflag*/	
			.word 0x00000000 /*c_cflag*/	
			.word 0x00000000 /*c_lflag*/	
			.byte 0x00	/*c_line*/	
			.word 0x00000000 /*c_cc[0-3]*/	
			.word 0x00000000 /*c_cc[4-7]*/	
			.word 0x00000000 /*c_cc[8-11]*/	
			.word 0x00000000 /*c_cc[12-15]*/
			.word 0x00000000 /*c_cc[16-19]*/
			.word 0x00000000 /*c_cc[20-23]*/
			.word 0x00000000 /*c_cc[24-27]*/
			.word 0x00000000 /*c_cc[28-31]*/
			.byte 0x00	/*padding*/
			.hword 0x0000	/*padding*/
			.word 0x00000000 /*c_ispeed*/
			.word 0x00000000 /*c_ospeed*/	
			
