#include "file_browser.h"

int chooseFile(char* selected, char* curpath, char* scrbuf) {
    int fileSelected = 0, cancelled = 0, enterPressed = 0, refresh = 1;   //false, false, false, true
    int numfiles, selectPos = 0, cursorWidth;
    char maxlines = (240-CHAR_HEIGHT)/(CHAR_HEIGHT);
    int cursorPos = 0, listStart = 0;
    char** fileList = malloc(1024); //safe number
    while(!fileSelected && !cancelled) {
        refresh = 1;
        numfiles = listdir(curpath, fileList);  //list of files stored to fileList
        while(!cancelled && !enterPressed) {
            if(refresh!=0) {   //refresh the browser
                puts(curpath);

                clearBuffer(scrbuf);    //clear screen
                putString(scrbuf, curpath, 0, 0, 0);   //show the current path
                cursorPos = selectPos - listStart;
                cursorWidth = putString(scrbuf, "> ", 0, (cursorPos+1) * CHAR_HEIGHT, 0); //
                int i;
                for(i = 0; i + listStart < numfiles && i < maxlines; i++) {
                    putString(scrbuf, fileList[i + listStart], cursorWidth, CHAR_HEIGHT * (i+1), 0);
                }
                memcpy(SCREEN_BASE_ADDRESS, scrbuf, SCREEN_BYTES_SIZE);
                sleep(150);
                refresh = 0;
            }
            if(isKeyPressed(KEY_NSPIRE_8)||isKeyPressed(KEY_NSPIRE_UP_NTP)) {
                selectPos--;    //move cursor up
                if(selectPos < 0)   selectPos = numfiles - 1;   //wrap to bottom
                if(selectPos > listStart + maxlines)    listStart = selectPos - maxlines;   //shift the list up with cursor
                if(selectPos < listStart)   listStart = selectPos;  //shift the list down with cursor
                refresh = 1;
            }
            if(isKeyPressed(KEY_NSPIRE_5)||isKeyPressed(KEY_NSPIRE_DOWN_NTP)) {
                selectPos++;
                if(selectPos >= numfiles)   selectPos = 0;
                if(selectPos > listStart + maxlines)    listStart = selectPos - maxlines;
                if(selectPos < listStart)   listStart = selectPos;
                refresh = 1;
            }
            if(isKeyPressed(KEY_NSPIRE_ESC)) {
                cancelled = 1;
                break;
            }
            if(isKeyPressed(KEY_NSPIRE_ENTER)) {
                enterPressed = 1;
                break;
            }
        }
        //strcat(curpath,fileList[selectPos]);
        puts(curpath);

        if(enterPressed) {
            puts("Enter Pressed");
			char* selected = fileList[selectPos];
			puts(selected);
			if(strcmp(selected,".")!=0) {
			    puts("Not '.'");
				if(strcmp(selected,"..")==0) {
				    puts("Is '..'");
					curpath[strlen(curpath)-1]=0;
					puts("removing last slash");
					puts(curpath);
					char* p = strrchr(curpath,'/');
					if(p)	*(p+1)=0;
					puts("Navigating up to ");
					puts(curpath);
                    sleep(200);
				} else {
                    strcat(curpath,selected);
                    puts(curpath);
					if(chdir(curpath)!=0) { //navigating failed, it's a file
						fileSelected=1;
					} else {
					    puts("successfully navigated");
						strcat(curpath,"/");
						sleep(200);
					}
				}
			}
            enterPressed = 0;
		}
    }
    return !cancelled;
}

int listdir(char* curpath, char** result) {
    /*struct dstat* file;
    chdir(curpath);
    if(NU_Get_First(file, "*.*")) { //0 (false) when there is no error
        NU_Done(file);  //there is no file
        return 0;
    }
    int i = 0;
    do {
        char* dirname = malloc(128);
        strcpy(dirname, (char*)(file->filepath));
        result[i] = dirname;
        i++;
    } while (NU_Get_Next(file) == 0);   //
    NU_Done(file);
    return i;*/
    unsigned char StructDstat[512];
    chdir(curpath);
    if (NU_Get_First((struct dstat*)StructDstat, "*.*")) {
        printf("Error: dirlist() failed to find file\n");
        NU_Done((struct dstat*)StructDstat);
        return -1;
    }
    int i = 0;
    do {
        char* dirname = (char*) malloc(128);
        strcpy(dirname, (char*) &StructDstat[13]);
        result[i] = dirname;
        i++;
    } while (NU_Get_Next((struct dstat*)StructDstat) == 0);
    NU_Done((struct dstat*)StructDstat);
    return i;
}
