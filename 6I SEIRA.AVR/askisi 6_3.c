/*****AVR(1/4) exersize3****/

#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
	DDRB = 0xFF;  // set output port
	DDRD = 0x00;  // set input port
	//PORTD = 0xFF; // pull up resistors
	volatile int input, output = 0x01;
	int i, priority = -1;
	int leftmost;
		
    while(1)
    {
		leftmost = -1;
		input = PIND;
		for (i = 4 ; i >= 0 ; i--) {
			if ((input & 0x10) != 0x00) {
				leftmost = i;
				break;
			}
			input = input << 1;
		}
		if (priority <= leftmost)
			priority = leftmost;
		else {
			if (priority == 4)
				output = 0x01;
			else if (priority == 3) {
					switch(output) {
						case 0x02 : output = 0x80;
							break;
						case 0x01 : output = 0x40;
							break;
						default: output = output >> 2;
							break;
					}
			}
			else if (priority == 2) {
				switch(output) {
					case 0x80 : output = 0x02;
						break;
					case 0x40 : output = 0x01;
						break;
					default: output = output << 2;
						break;
				}
			}
			else if (priority == 1) {
				switch(output) {
						case 0x01 : output = 0x80;
							break;
						default: output = output >> 2;
							break;
							}
			else if (priority == 0)
				output = (output == 0x80) ? (output = 0x01) : (output << 1);		
			}
			PORTB = output;
			priority = leftmost;
		}
			
}
