#ifndef BOOK_DISPLAY_H_INCLUDED
#define BOOK_DISPLAY_H_INCLUDED

#include <os.h>
#include "chars.h"
#include "textout.h"

int getWordAt(char* bookData, unsigned long size, unsigned long pos, char* word);
unsigned long displayPage(char* scrbuf, char* bookData, unsigned long size, unsigned long pos);

#endif // BOOK_DISPLAY_H_INCLUDED
