#ifndef TEXTOUT_H_INCLUDED
#define TEXTOUT_H_INCLUDED

#define bold 1

#include <os.h>
#include "chars.h"

int putString(char* scrbuf, char* c, int x, int y, int format);
int putChar(char* scrbuf, char c, int x, int y, int format);
int stringWidth(char* str);
int charWidth(char c);

#endif // TEXTOUT_H_INCLUDED
