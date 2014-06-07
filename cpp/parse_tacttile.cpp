/*
 * \author Ben Axelrod
 * \date   Novermber 2013
 *
 * Parses arduino takktile data in the format:
 * [[327],[335],[331],[324],[351],[319],[337],[347],[345],[347]]\r\n
 *
 **/

#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>

#include <string>
#include <vector>

#define BAUD B9600
#define DEFAULT_MODEM "/dev/ttyACM0"
#define BUFFER_LEN 500

volatile bool run = true;
void sigint_handler(int s)
{
    run = false;
};


int main(int argc, char** argv)
{
    std::string modem = DEFAULT_MODEM;

    if (argc >= 2)
    {
        modem = argv[1];
    }
    
    unsigned int baud = BAUD;
    
    printf("setting up signal handler\n");
    struct sigaction sa;
    sa.sa_handler = sigint_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART; //required or segfault on CTRL-C
    if (sigaction(SIGINT, &sa, NULL) == -1) 
    {
        perror("sigaction");
        exit(1);
    }

    printf("trying to open\n");
    int fd = open(modem.c_str(), O_RDWR | O_NOCTTY);// | O_NDELAY); //blocking
    //int fd = open(modem.c_str(), O_RDWR | O_NOCTTY | O_NDELAY);  //non-blocking
    if (fd <0 ) 
    {
        printf("cannot open device\n");
        perror(modem.c_str()); 
        exit(-1); 
    }
    printf("device open\n");
    
    /////////////////////////////////
    printf("configuring device\n");

    struct termios options;
    tcgetattr(fd, &options);
    cfmakeraw(&options);
    cfsetspeed(&options, baud);
    options.c_cflag |= (CLOCAL | CREAD);
    options.c_cflag &= ~PARENB;  // no parity
    options.c_cflag &= ~CSTOPB;  // 1 stop bit, not 2
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS8;      // 8 data bits
    options.c_cflag &= ~CRTSCTS; // no CTS/RTS hardware flow control
    options.c_cc[VTIME]    = 5;  // 0.3 second timeout
    options.c_cc[VMIN]     = 1;  // don't block for a number of chars
    tcflush(fd, TCIOFLUSH);      // flushes both directions
    tcsetattr(fd, TCSANOW, &options);

    printf("device configured\n");    
    //////////////////////////////

    char buf[BUFFER_LEN];
    memset(buf, 0, BUFFER_LEN);
    int token = 0;
    
    while (run)
    {
        int res = read(fd, &(buf[token]), BUFFER_LEN-token-1);
        if (res < 0)
        {
            printf("\nWARNING: read returned %d\n", res);
        }
        else if (res > 0)
        {
            token += res;
            buf[token]='\0';
            
            // look for end character
            for (int i=token; i>0; i--)
            {
                // found end
                if (buf[i-1] == 0x0D && buf[i] == 0x0A)
                {
                    //printf("raw: %s",buf);
                    
                    std::vector<int> vals;
                    char* pch = strtok(buf,"[],\r\n");
                    while (pch != NULL)
                    {
                        //printf("%s ",pch);
                        vals.push_back(atoi(pch));
                        pch = strtok (NULL, "[],\r\n");
                    }
                    token = '\0';
                    //printf("\n");
                    
                    if (vals.size() == 10)
                    {
                        printf("vals: ");
                        for (int i=0; i<10; i++)
                            printf("%d ", vals[i]);
                        printf("\n");
                    }
                    else
                    {
                        //printf("error: not 10\n");
                    }
                    
                    break;
                }
            }
        }
    }
    
    printf("closing\n");
    close(fd);
    printf("exiting\n");
    exit(0);
}
