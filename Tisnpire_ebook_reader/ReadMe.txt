+-----------------------+
|                       |
|  Nspire Ebook Reader  |
|      Version 0.1      |
|                       |
+-----------------------+

Controls:
---------
 o Up/Down or 5/8 to navigate the file browser
 o Enter to open the file
 o Left/Right or 4/6 to turn the page

Known bugs:
-----------
 o The text right now is really small (7pt Tahoma) and there is currently no option to change it.
 o There may also be a small memory leak-I haven't checked through all the code to make sure all the dynamically allocated memory gets freed.
 o It currently doesn't check if you've reached the end of the book, so you might get garbled stuff at the very end.

Future additions:
-----------------
 o Ability to change the font size and the vertical spacing between lines
 o Support of a more compact file format
 o Support for bold and italics
 o Page numbers and a jump to page option.

Disclaimer:
-----------
This program is still in a beta stage, so I can't guarantee its stability. You use this at your own risk.

License:
--------
Feel free to modify and distribute this code. In fact, please do so, as I might not have very much time to work on this. Just make sure I get a little bit of credit.

Credits:
--------
Many thanks to critor for letting me use some of the file browsing code from mViewer.