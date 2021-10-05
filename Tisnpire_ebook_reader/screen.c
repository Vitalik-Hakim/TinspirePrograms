#include "screen.h"

void setPixel(char* scrbuf, int x, int y, char color) {
    int loc = (y * SCREEN_WIDTH + x)/2;
    scrbuf[loc]=(x&1) ? (scrbuf[loc]&0xF0)|color : (scrbuf[loc]&0x0F)|(color*0x10);
    return;
}

void clearBuffer(char* scrbuf) {
    unsigned char *p = (unsigned char*)scrbuf;
    int i;
    for(i = 1; i < SCREEN_BYTES_SIZE; i++) {
        *p = 0xFF;
        p++;
    }
    return;
}
