#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <strings.h>

#define _POSIX_SOURCE 1
#define DEVICE "/dev/pts/19"
#define BAUDRATE B9600

int send(int fd, char *string){	/*sinartisi gia apostoli tou string*/
	
	int length = strlen(string);
	int i,nb;
	for (i=0; i<=length; i++){
		nb=write(fd,&string[i],1);
		if (nb<1)
			perror("Error: Couldn't write all characters");
		tcdrain(fd);
	}
	printf("esteila ta data\n");
	return nb;
}

int receive(int fd, char *string){ /*sinartisi gia dimiourgeia tou string pou lamvanete apton guest*/
	
	int i=0;
	int r; char c;

	r=read(fd,&c,1); 
	while (c!='\n'){
		if (r>0){
			string[i++]=c;}
		r=read(fd,&c,1);
		if (r<0){
			perror("read");
			exit(1);}
	}

	return i;
}

int main(){
	

	struct termios tio;
	int tty_fd;
	int fd,count=0;
	char *inp, *outp, ch, *command;
	command = (char *)calloc(1000,sizeof(char));
	inp = (char *)calloc(65,sizeof(char));	/*arxikopoiisi theseon mnimis gia input*/
	outp = (char *)calloc(64,sizeof(char)); /*arxikopoiisi theseon mnimis gia output*/

	puts("Please give a string to host: ");
	ch=getchar();	/*topothetisi xaraktiron apto pliktrologio sto input table*/
	while (ch!='\n'){
		inp[count++] = ch;
		ch = getchar();
	}
	inp[count] = '\0';

	fd = open(DEVICE, O_RDWR | O_NOCTTY); /*anoigma tis thiras*/
	if (fd<0){ perror(DEVICE); exit(-1);}

	//initilisation of the members of the termios stucture
        memset(&tio,0,sizeof(tio));
	//initilisation of the input modes(turn off input processing)
        tio.c_iflag=0;
	//initilisation of the output modes(turn off output processing)
        tio.c_oflag=0;
	//initilisation of the control modes with character size 8 buts, enabled receiver and ignoring modem status lines
        tio.c_cflag=CS8|CREAD|CLOCAL;
	//initilisation of the local modes(no line processing)
        tio.c_lflag=0;
	//initilisation of the minimum input bytes needed to return from read and the  limit of a timer for input 
        tio.c_cc[VMIN]=1;
        tio.c_cc[VTIME]=5;


	//configure baud rate speed of input and output
        cfsetospeed(&tio,B9600);            
        cfsetispeed(&tio,B9600);
 
	//clear serial port and activate
	tcflush(tty_fd, TCIFLUSH);
        tcsetattr(tty_fd,TCSANOW,&tio);		


	send(fd, inp);	/*apostoli string gia epeksergasia sto guest mixanima*/
	receive(fd, outp); /*dexete tin apantisi tou guest mixanimatos*/
	puts(outp); /*tiponei tin apantisi stin othoni*/
	return 0;
}
