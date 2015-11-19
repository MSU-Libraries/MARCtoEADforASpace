# MARCtoEADforASpace
XSLT stylesheet for converting MARC records to EAD using MarcEdit.

## Instructions on installing stylesheets in MarcEdit

(From http://marcedit.reeset.net/software/xslt/load.txt)

1. Just put the XSLT sheet into the c:\program files\marcedit\xslt directory and follow the steps below.
2. Click on the MARC Tools menu at: Tools/Edit XML Function List/
3. Click the Add Button
4. Function Name (Alias) -- Enter: MARC=>RDFDC
5. XSLT Stylesheet path: Click on the open folder Icon and find the RDF style sheet that you just downloaed.
6. In format information, select MARC as the original format and Other as the final format.
7. Click Ok (close the Add dialog)
8. Click Cancel (close the Edit XML Function list
9. You will now see the option in the XML function list.

Just select it and specifiy the file that you wish to process.  Its really that simple.

## Author Notes
I've commented in the stylesheet where I made decisions and my thoughts behind them.  

I'm a n00b at XSLT, so if anyone sees issues or improvements, please let me know.  I am also new at GitHub, so patience is appreciated!
