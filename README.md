# lifelong_learning
A bash &amp; awk script for self-preparation for Exams. Load files with questions and answers for preparation for any exam
Lifelong Learning script 

To hard stop the script press "Ctrl + C"
To soft stop the already started Q&A check with displaying a report, type "exit!"
To shuffle the Q&A in file to read Q&A from, pass "r" as a second argument after the name of the file, separated by a space.

Load a file with questions and answers 
===========================
Part of the pre-checks: 
Questions and answers in a file to be loaded have to be separated with a colon  ":"  ex. questions on the left side, answers on right side of the : 
No more than one ":" allowed per line - this will be the delimiter between questions and answers
===========================
If there are multiple answers, they have to be separated by semi-colon ;
The script checks the number of expected answers, the  squequence of provided answers is irrelevant
For each question you will be notified about the number of expected answers.  
Provided answers also have to be submitted in the prompt with ; as a separator
To compare the answers from file with provided answers, both of them are made lower case and multiple spaces are trimmed to a single space.  
If you have loaded a file and a check has started you can stop and have the report displayed by typing "exit!" 
You will be prompted if you want to save the questions and asnwers you donot know in a new file - in case there are such questions. If you scored 100% this options is not available.   
If you have a question of the type "fill in the blanks" the order of the answers is not checked as long as all the answers are correct so it has to be taken into consideration. 
