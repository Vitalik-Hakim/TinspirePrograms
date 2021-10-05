#ifndef SCREEN_H_INCLUDED
#define SCREEN_H_INCLUDED

#include <os.h>

void setPixel(char* scrbuf, int x, int y, char color);
void clearBuffer(char* scrbuf);

#endif // SCREEN_H_INCLUDED
