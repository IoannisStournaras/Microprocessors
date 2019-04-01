#include <avr/io.h> 
#include <stdio.h> 

int main(void){
	DDRA = 0b00000111;														//Arxikopoihsh thiras eksodou
	DDRC = 0b00011111;														//Arxikopoihsh thiras eisodou

	uint8_t temp, tempA, tempB, tempC, tempD, tempE;	
	uint8_t F0, F1, F2;

	while(1){
		tempA = (PINC & (1<<PC0));
		tempB = (PINC & (1<<PC1));
		tempB = tempB >> 1;
		tempC = (PINC & (1<<PC2));
		tempC = tempC >> 2;
		tempD = (PINC & (1<<PC3));
		tempD = tempD >> 3;
		tempE = (PINC & (1<<PC4));
		tempE = tempE >> 4;
		
		F0 = ~((tempA & tempB) | (tempB & tempC) | (tempC & tempD) | (tempD & tempE));
		F1 = ((tempA & tempB & tempC & tempD) | (~tempD & ~tempE));
		F2 = (F0 | F1);
		
		F0 = F0 & 0b00000001;
		F1 = F1 << 1;
		F1 = F1 & 0b00000010;
		F2 = F2 << 2;
		F2 = F2 & 0b00000100;
		
		PORTA = (F0 | F1 | F2);

		

	}		
}				