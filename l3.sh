#!/bin/bash

#text in color
Red='\033[0;31m'
Blue='\033[0;34m'
Green='\033[0;32m'
Bright_Blue='\033[0;94m'
Bright_Yellow='\033[0;93m'
Bright_Cyan='\033[0;96m'
Magenta='\033[0;35m'
Bright_Green='\033[0;92m'
Cyan='\033[0;36m'
Light_Grey='\033[0;37m'
Dark_Grey='\033[0;90m'
Bright_Red='\033[0;91m'
Bright_Magenta='\033[0;95m'
Bright_White='\033[0;97m'
EOC='\033[0m'

# Functions start 
function next_dict_loading() {

if [[ -f words_to_revise ]]
then
echo 'Do you want to save only the Q&A to revise in another file for another run?'
echo   
select Load_Next_Dict in  'Yes, save the Q&A in another file' 'Skip this step'; do 
break; 
done

if [[ $Load_Next_Dict == 'Yes, save the Q&A in another file' ]]
then 
read -p "Please a provide name of the file to save them in: " EnterFileNameTempDict
if [[ ! -z $EnterFileNameTempDict ]]
then 
cp preloaded_word_to_revise_next $EnterFileNameTempDict 
if [[ -f $EnterFileNameTempDict ]] && [[ ! -z $EnterFileNameTempDict ]]
then
echo -e 'A new file with Q&A to revise has been created under the name: ' $Cyan$EnterFileNameTempDict$EOC
else 
echo 'Error while creating the file.'
fi
fi
else 
echo 'Saving the Q&A to revise in a new file not requested.'
fi
fi
echo
echo '___ Non scholae sed vitae discimus ___'
}

function remove_files() {
array_files_to_remove=(words_you_know words_to_revise dict_copy preloaded_word_to_revise_next questions_you_know questions_to_revise dict_copy obj_parsed_answer parsed_answer preloaded_word_to_revise_next temp_container words_to_revise words_you_know) 
for x in ${array_files_to_remove[@]}; do 
if [[ -f $x ]]
then
#echo 'removing file' $x
rm $x
fi
done
echo 'Removing old working files, if any'
}

function func_recap() {
echo
if [[ -f words_you_know  ]]
then
echo '===' 'What you know:' '==='
echo
cat words_you_know  
echo
fi 

if [[ -f words_to_revise ]]
then
echo '===' 'What to revise:' '==='
echo
cat words_to_revise  
echo
fi
echo -e $Bright_Green'==============='$EOC
echo -e $Bright_Blue 'Report:' $EOC
time_now_2=$(date +%H:%M:%S)
#echo $time_now_
var_end_time=$time_now_2
echo
if [[ -f words_you_know ]]
then 
let known_words=$(awk '{print NR}' words_you_know | tail -1)

echo -e 'Number of correct answers'   $Bright_Green  $known_words $EOC
fi 

if [[ -f words_to_revise ]]
then 
let unknown_words=$(awk '{print NR}' words_to_revise | tail -1)

echo -e 'Number of incorrect answers' $Red $unknown_words $EOC
fi

echo -e 'Total number of questions' $Blue$counter $EOC

percent_rate=$(awk -v knw=$known_words -v total=$counter 'BEGIN {print ((knw/total) * 100)}')
rounded_percent=$(awk -v percent=$percent_rate 'BEGIN {printf "%.2f", percent}')
echo 'Success rate' ':' $rounded_percent'%' 
echo '----------------'
echo 'Start time:' $var_start_time
echo 'End time:' $var_end_time
echo '----------------'
echo -e $Bright_Green'==============='$EOC

}

function_help() {
echo -e $Blue'----------------------------------------------------------------------------'$EOC
echo -e $Blue'Help Menu:'$EOC
echo 'To hard stop the script press "Ctrl + C"'
echo 'To soft stop the already started Q&A check with displaying a report, type "exit!"'
echo 'To shuffle the Q&A in file to read Q&A from, pass "r" as a second argument after the name of the file, separated by a space.'
echo -e $Blue'----------------------------------------------------------------------------'$EOC
}
# Functions end 

# Script start 
# Help menu
function_help
#random start

# random end
remove_files
echo -e $Green"_____________"$EOC
echo -e $Green" |__Start__|"$EOC

echo -e $Bright_Blue'Please load the file with questions and answers' $EOC
read File_loaded Random_Mode
sed -i '/^$/d' $File_loaded
if [[ $Random_Mode == 'r' ]]
then
echo -e $Cyan'Random mode switched on'$EOC
random_mode='ON' 
else 
random_mode='OFF' 
fi
#File_loaded=q_a.txt

#pre-checks
if [[ ! -f $File_loaded ]]
then 
echo -e $Red 'File does not exist. Please check. Exit.' $EOC
else 
echo 'File exists'
fi
proceed=true
while read line; do 
line_no=1
if [[ $line =~ ":" ]]
then 
continue
else
echo -e $Bright_Blue'->'$EOC $Bright_Yellow $line $EOC
proceed=false
fi
((line_no++))
done < $File_loaded

if [[ $proceed == false ]]
then 
echo '--------------'
echo -e $Red'The line(s) above does/do not contain a : as a delimiter. Please add it and save the file. Exit.'$EOC
fi

awk -F\: -v line=$0 '{print NF-1,"<- number of colon characters : as separator. Only one colon as separator per line allowed, content", $0}' $File_loaded > check_colons

while read line; do 
if [[ ${line: 0:1} != '1' ]]
then
echo $line
fix_colon_per_line='true' 
fi
done < check_colons
rm check_colons
if [[ $fix_colon_per_line == "true"  ]]
then 
echo -e $Red'Fix issues above.'$EOC 
fi

if [[ $proceed == false ]] || [[ $fix_colon_per_line == "true"  ]]
then
echo 'Exit' 
exit
fi

# random Mode in file copy
if [[ $random_mode == 'ON' ]]
then 
cat $File_loaded | shuf > dict_copy
else 
cp $File_loaded dict_copy
fi
dos2unix dict_copy
sed -i 's/^M//g' dict_copy
sed -i '/^$/d' dict_copy
sed -i 's/^M//g' dict_copy  
sed -i 's/[ ][ ]*/ /g' dict_copy
sed -i 's/^[[:space:]]*//' dict_copy
sed -i 's/$[[:space:]]*//' dict_copy
sed -i 's/$/:/g' dict_copy
sed -i 's/ : /:/g' dict_copy
sed -i 's/: /:/g' dict_copy
sed -i 's/ :/:/g' dict_copy
echo "end_of_lines:end_of_lines:" >> dict_copy
# =========================
#Questions and answers  
# ========================= 

# Avoid EOF 
last_line=$(awk '{print NR}' dict_copy | tail -1)
continue_check=true
echo
echo -e $Bright_Cyan'=== ''Starting check'' ==='$EOC
time_now=$(date +%H:%M:%S)
#echo $time_now
var_start_time=$time_now
counter=0
random_line=1
question_number=1
while [[ $continue_check == true ]]; do
question_asked=$(awk -v rand_l=$random_line 'BEGIN {FS = ":"} ; {if (NR == rand_l) print $1}' dict_copy)
answer_expected=$(awk -v rand_l=$random_line 'BEGIN {FS = ":"} ; {if (NR == rand_l) print $2}' dict_copy)

question_asked=${question_asked}
answer_expected=${answer_expected,,}

if [[ $question_asked  == "end_of_lines" ]] && [[ $answer_expected  == "end_of_lines" ]]
then 
echo
echo -e $Cyan'---------------------------------'$EOC  
echo              'END'    
echo -e $Cyan'---------------------------------'$EOC  
func_recap
next_dict_loading
exit
fi
echo
echo -e $Bright_Green'->'$EOC "Question No.$question_number:" $Bright_Blue $question_asked $EOC
#echo 'number of lines' $last_line $random_line
((question_number++))

if [[ $answer_expected =~ ";" ]]
then 
await_answer_edit=$(sed 's/;/ ; /g' <<< ${await_answer}) 
await_answer=$await_answer_edit
await_answer_edit=$(sed 's/[[:space:]]*;[[:space:]]*/ ; /g' <<< ${await_answer}) 
await_answer=$await_answer_edit
echo $answer_expected > temp_container
num_colons=$(awk 'BEGIN {FS = ";"} ; {print NF}' temp_container)
echo -e $Bright_Green'Number of answers expected, delimited by ";" ='$num_colons $EOC
fi

read await_answer

echo -e $Green'-----------------'$EOC
echo $question_asked ' -> '$answer_expected
echo -e $Green'-----------------'$EOC

#echo ${#await_answer}
await_answer_edit=$(sed 's/[[:space:]]*$//g' <<< ${await_answer}) 
await_answer=$await_answer_edit
await_answer_edit=$(sed 's/^[[:space:]]*//g' <<< ${await_answer}) 
await_answer=$await_answer_edit
await_answer_edit=$(sed 's/[ ][ ]*/ /g' <<< ${await_answer}) 
await_answer=$await_answer_edit

await_answer=${await_answer,,}

if [[ $answer_expected =~ ";" ]]
then 

awk -v no_cols=$num_colons 'BEGIN {FS = ";"} {for (x=1; x <= no_cols; ++x) print $x}' <<< $await_answer > parsed_answer
awk -v no_cols=$num_colons 'BEGIN {FS = ";"} {for (x=1; x <= no_cols; ++x) print $x}' <<< $answer_expected > obj_parsed_answer
sed -i 's/^[[:space:]]*//g' parsed_answer
sed -i 's/^[[:space:]]*//g' obj_parsed_answer
num_matches=0
while read line; do 
while read line_f2; do 

if [[ $line == $line_f2 ]]; 
then 
((num_matches++))
fi

done < parsed_answer
done < obj_parsed_answer

#echo 'Matches' $num_matches 
fi

if [[ $await_answer == "exit!" ]]
then
echo -e $Cyan'Exit on request'$EOC
func_recap
next_dict_loading
break
exit
fi

if [[ $answer_expected =~ ";" ]]
then 

if [[ $await_answer ==  $answer_expected ]]  || [[ $num_colons == $num_matches ]]
then 
echo $question_asked ':' $answer_expected >> words_you_know
echo -e $Bright_Green 'Correct' $EOC
else
echo $question_asked ':' $answer_expected >> words_to_revise
echo -e $Red'Incorrect' $EOC
echo $question_asked ':' $answer_expected >> preloaded_word_to_revise_next 
fi
else 



if [[ $await_answer ==  $answer_expected ]] 
then 
echo $question_asked ':' $answer_expected >> words_you_know
echo -e $Bright_Green 'Correct' $EOC
else
echo $question_asked ':' $answer_expected >> words_to_revise
echo -e $Red'Incorrect' $EOC
echo $question_asked ':' $answer_expected >> preloaded_word_to_revise_next 
fi

fi 

counter=$(expr $counter + 1)

#echo 'Counter:' $counter

((random_line++))
#echo $random_line
done 
#fi 
echo 
