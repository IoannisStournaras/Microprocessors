.text
.align 4 /* allignment tou kodika */
	.global strcpy
		.type strcpy, %function
	.global strcmp
		.type strcmp, %function
	.global strlen
		.type strlen, %function
	.global stlcat
		.type strcat, %function



strcpy:
	stmfd sp!, {r0-r2, fp, lr}
loopaki:
	ldrb r2,[r1],#1 	/*fortonei ston r2 to 1on xaraktira kai auksanei ton r1*/
	strb r2,[r0],#1 	/*sozei sti dieuthinsi tou r0 ton r2 kai auksanei kata 1*/
	cmp r2,#0		/*sinexizei oso diaforo tou '/0'*/
	bne loopaki
	ldmfd sp!, {r0-r2, fp, lr} /*epistrefei r0 na deixnei sto destination tou string*/
	bx lr



strcmp:
	stmfd sp!, {r1-r3, fp, lr}
cont:
	ldrb r2,[r0],#1	/* xaraktires tou 1ou string*/
	ldrb r3,[r1],#1	/* xaraktires tou 2ou string*/
	cmp r2,r3

	movlt r0,#-1 
	movgt r0,#1
	bne exit /*an ena apta 2 string teleiosei o xaraktiras /0 tha vgei mikroteros sti sigrisi kai tha termatisei*/
	cmp r2,#0 /* gi auto elegxoume /0 mono an einai equal, an einai idia kai dn exoun teleiosei sinexizoume */
	bne cont
	moveq r0,#0
exit:
	ldmfd sp!, {r1-r3, fp, lr}
	bx lr



strlen:
	stmfd sp!, {r1-r2, fp, lr}
	sub r1,r0,#1	/*gia na ipologisoume sosta stin 1i epanalipsi*/
next:
	ldrb r2,[r1,#1]! /*fortonoume ston r2, ti dieuthinsi tou r1+1 kai enimeronoume ton r1*/
	cmp r2,#0
	bne next
	sub r0,r1,r0 /*length = end of string-beginning*/
	ldmfd sp!, {r1-r2, fp, lr}
	bx lr



strcat:
	stmfd sp!, {r2, fp, lr}
	mov r2,r0 /*r2 has the beginning of the 1nd string*/
	bl strlen
	add r0,r2,r0 /*r0 has the end of the 1st string +1*/
	bl strcpy    /*sto telos tou 1ou string antigrafo to 2o string dimiourgontas to concatinated string*/
	mov r0,r2   /* o r0 tha deixnei etsi stin arxi tou concatinated string */
	ldmfd sp!, {r2, fp, lr}
	bx lr
			
