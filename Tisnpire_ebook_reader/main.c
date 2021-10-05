
#include <os.h>
#include "screen.h"
#include "textout.h"
#include "file_browser.h"
#include "book_display.h"

struct page {struct page* previous; struct page* next; unsigned long position; unsigned long pageNumber};

char* numToStr(int num) {
    char* str;
    char digit[]="0123456789ABCDEF";
    int numcopy=num;
    int numdigits=0;
    while(numcopy>0) {
        numcopy/=10;
        numdigits++;
    }
    int i=0;
    str=malloc(numdigits+1);
    while(num>0) {
        str[numdigits-i-1]=digit[num%10];
        num/=10;
        i++;
    }
    str[i]=0;
    return str;
}

int main(int argc, char* argv[]) {
    char* scrbuf;
    scrbuf = malloc(SCREEN_BYTES_SIZE);
	memcpy(scrbuf, SCREEN_BASE_ADDRESS, SCREEN_BYTES_SIZE);

    clearBuffer(scrbuf);

    memcpy(SCREEN_BASE_ADDRESS, scrbuf, SCREEN_BYTES_SIZE);

    char path[128];
	strcpy(path, argv[0]);
	char* lastSlash = strrchr(path, '/');
	if(lastSlash) *(lastSlash + 1) = 0; //terminate the string after the last '/'
    char* selected;
    puts(path);
	unsigned intmask = TCT_Local_Control_Interrupts(0);
	TCT_Local_Control_Interrupts(intmask);
    memcpy(SCREEN_BASE_ADDRESS, scrbuf, SCREEN_BYTES_SIZE);
    chooseFile(selected, path, scrbuf);
    puts(path);

    //openFile(selected, scrbuf);
    //puts(selected);
    FILE* book = fopen(path, "rb"); //open the selected file with binary read permissions
    if(book) puts("Successfully opened");

    //get file size
    unsigned long size;
    unsigned char* StructDstat = malloc(512);   //allocate memory for file properties
    if (NU_Get_First((struct dstat*)StructDstat, path)==0) {   //if there's no error generated by getting the file properties
        size = ((struct dstat*)StructDstat)->fsize; //set the size
    } else {
        free(scrbuf);
        return -1;
    }
    puts("checkpoint 1");

    char* bookData = malloc(size);
    size_t bytesRead = fread(bookData, 1, (size_t)size, book);

    //print out unsigned longs as binary
    char* p = (char*)&bytesRead;
    char* num = malloc(sizeof(unsigned long)*8+1);
    int i;
    for(i = 0; i<sizeof(unsigned long)*8; i++) {
        if(((bytesRead>>i) & (1))==1) {
            num[sizeof(unsigned long)*8-1-i]='1';
        } else {
            num[sizeof(unsigned long)*8-1-i]='0';
        }
    }
    num[sizeof(unsigned long)*8]=0;
    puts(num);

    clearBuffer(scrbuf);

    puts("checkpoint 2");
    struct page *currentPage, *firstPage;
    currentPage = malloc(sizeof(struct page));
    firstPage=currentPage;
    currentPage->previous = 0;
    currentPage->next = 0;
    currentPage->position = 0;
    currentPage->pageNumber = 0;
    unsigned long endpos;
    int exit = 0, waitkey;
    if(bytesRead==size) {
        while(!exit) {
            waitkey = 1;
            clearBuffer(scrbuf);
            endpos = displayPage(scrbuf, bookData, size, currentPage->position);
            putString(scrbuf, numToStr(currentPage->pageNumber), 0, 0, 0);
            puts(numToStr(currentPage->pageNumber));
            //puts("displaying page");
            while(waitkey) {
                sleep(100);
                if(isKeyPressed(KEY_NSPIRE_6)||isKeyPressed(KEY_NSPIRE_RIGHT_NTP)) {
                    if(currentPage->next==0) {
                        //puts("new struct");
                        currentPage->next = malloc(sizeof(struct page));   //create a new node
                    }
                    currentPage->next->previous = currentPage;  //set the new node
                    currentPage->next->next = 0;
                    currentPage->next->position = endpos;
                    currentPage->next->pageNumber = currentPage->pageNumber + 1;
                    currentPage = currentPage->next;
                    waitkey = 0;
                    //puts("forward");
                }
                if(isKeyPressed(KEY_NSPIRE_4)||isKeyPressed(KEY_NSPIRE_LEFT_NTP)) {
                    if(currentPage!=firstPage) {  //we're not the the start
                        currentPage = currentPage->previous;    //no new node to initialize; it has to already exist
                    }
                    waitkey = 0;
                    //puts("backward");
                }
                if(isKeyPressed(KEY_NSPIRE_ESC)) {
                    exit = 1;
                    //puts("exiting");
                    break;
                }
            }
            //puts("out of loop");
        }
    }

    while (!isKeyPressed(KEY_NSPIRE_ESC)) {}

    clearBuffer(scrbuf);

    memcpy(SCREEN_BASE_ADDRESS, scrbuf, SCREEN_BYTES_SIZE);

    while (!isKeyPressed(KEY_NSPIRE_ESC)) {}
    free(scrbuf);
    free(bookData);
    fclose(book);
	return 0;
}
