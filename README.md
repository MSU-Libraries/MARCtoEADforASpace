# MARCtoEADforASpace
XSLT stylesheet for converting MARC records to EAD using MarcEdit.

## Instructions on adding stylesheets in MarcEdit

(From http://marcedit.reeset.net/software/xslt/load.txt)

1. Just put the XSLT sheet into the c:\program files\marcedit\xslt directory and follow the steps below.
2. Click on the MARC Tools menu at: Tools/Edit XML Function List/
3. Click the Add Button
4. Function Name (Alias) -- Enter: MARC=>EADforASpace
5. XSLT Stylesheet path: Click on the open folder Icon and find the MARC2EAD4Apsace style sheet that you just downloaed.
6. In format information, select MARC as the original format and Other as the final format.
7. Set the XSLT engine to SAXON.
8. Click Ok (close the Add dialog)
9. Click Cancel (close the Edit XML Function list
10. You will now see the option in the XML function list.

Just select it and specifiy the file that you wish to process.  Its really that simple.

## Batch processing records in MarcEdit

If you're like my institution, you'll have one large MARC file with all your records.  You'll need use MARCSplit to seperate those into individual .mrc files.

Terry Reese has a tutorial on using MARCSplit and batch processing here: https://www.youtube.com/watch?v=M1J3QEyLzss

## Author Notes
I've commented in the stylesheet where I made decisions and my thoughts behind them.  

I'm a n00b at XSLT, so if anyone sees issues or places for improvements, please let me know.  I am also new at GitHub, so patience is appreciated!
