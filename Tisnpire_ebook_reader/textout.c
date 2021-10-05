#include "textout.h"
#include "screen.h"

int putString(char* scrbuf, char* c, int x, int y, int format) {
    int i=0;
    while(c[i]!=0) {
        int adv = putChar(scrbuf, c[i], x, y, format);   //returns the advance
        x+=adv;
        i++;
        if(c[i]==0) break;
    }
    return x;
}

int putChar(char* scrbuf, char c, int x, int y, int format) {
    int i, j;
    for(i=0; i<10; i++) {       //y offset
        for(j=0; j<16; j++) {   //x offset
            short pixelOn = charmap[(unsigned char)c][i] << j;
            pixelOn = pixelOn & 0x8000;
            if(pixelOn) {
                setPixel(scrbuf, x + j, y + i, 0x00);
                if(format==bold)
                    setPixel(scrbuf,x+j+1,y+1, 0x00);
            //} else {  //commented out to allow transparency
                //setPixel(scrbuf, x + j, y + i, 0x0F);
            }
        }
    }
    return charmap[(unsigned char)c][10];
}

int stringWidth(char* str) {
    int i = 0, width = 0;
    while(1) {
        width += charmap[(unsigned char)(str[i])][10];
        i++;
        if(str[i]==0) break;
    }
    return width;
}

int charWidth(char c) {
    return charmap[(unsigned char)c][10];
}
