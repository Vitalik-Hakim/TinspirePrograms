#include "book_display.h"

int getWordAt(char* bookData, unsigned long size, unsigned long pos, char* word) {
    static int ignore = 0;
    int i = 0;
    char c, next;
    while(pos<size-1) {
        c=bookData[pos];
        next=bookData[pos+1];
        if(i>0 && c==0x0d && next==0x0a) {  //
            //puts("case 1");
            //pos++;
            break;
        } else if(c==0x0d && next==0x0a) {
            //puts("case 2");
            word[0]=0x0d;
            word[1]=0x0a;
            word[2]=0;
            pos+=2;
            i+=2;
            break;
        }
        if(c=='<') ignore = 1;
        if(ignore==0){
            word[i]=c;
            i++;
        }
        if(c=='>') ignore = 0;
        pos++;
        if(c==' ') {
            //puts("case 3");
            break;
        }
    }
    word[i]=0;
    return pos;
}

unsigned long displayPage(char* scrbuf, char* bookData, unsigned long size, unsigned long pos) {
    //puts("checkpoint 3");
    int x = 0, y = 0;
    unsigned long i = pos, nextPos;
    char* word = malloc(128);
    int filled = 0;
    while(!filled && i<size) {
        nextPos=getWordAt(bookData, size, i, word);
        //puts(word);
        if((word[0]==0x0d || word[1]==0x0a)) { //carriage return
            //puts("new line");
            x=16;
            y+=CHAR_HEIGHT;
        } else {
            if((x+stringWidth(word))>SCREEN_WIDTH) {
                //puts("new line");
                x=0;
                y+=CHAR_HEIGHT;
            }
            if(y+CHAR_HEIGHT>SCREEN_HEIGHT) {
                filled = 1;
                break;
            }
            //if((x+stringWidth(word))>SCREEN_WIDTH) puts("wrapping");
            int adv = putString(scrbuf, word, x, y, 0);
            //puts(numToStr(stringWidth(word)));
            //puts(numToStr(adv));
            x=adv;
        }
        if(y+CHAR_HEIGHT>SCREEN_HEIGHT) {
            filled = 1;
            break;
        }
        i=nextPos;
    }
    memcpy(SCREEN_BASE_ADDRESS, scrbuf, SCREEN_BYTES_SIZE);
    return i;
}
