#ifndef FILE_BROWSER_H_INCLUDED
#define FILE_BROWSER_H_INCLUDED

#include <os.h>
#include "textout.h"
#include "screen.h"

int chooseFile(char* selected, char* curpath, char* scrbuf);
int listdir(char* path, char** result);

#endif // FILE_BROWSER_H_INCLUDED
