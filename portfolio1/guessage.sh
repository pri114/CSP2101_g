#Priscilla Pitchen
#Student No. 943222

#!/bin/bash

age="$(( $RANDOM % 50 + 21 ))"     #create a variable to generate a random number between 20 & 70
guess=""                           #create an empty variable to hold user guesses
guesscnt=0                         #create a counter for the guesses and set to zero


if ! [ -f "userguess.txt" ]; then  #if a file does not already exist
    touch userguess.txt            #create an empty file to hold the user's guesses
else
    echo "" >| userguess.txt       #else if the file exists overwrite it with an empty file        
fi

#Tell the user what they need to do
echo -e "\nCan you guess my age?\nMy name is Sue.\nI am aged between 20 and 70 years old. \n"              

#For as long as the guess does not equal age, ask the user to enter a guess or quit the game
while [ "$guess" != "$age" ]; do                                        
    read -p "How old do you think I am (enter 'q' to quit): " guess     
        
    #if the user enters 'q' than end the game
    if [ "$guess" == "q" ]; then 
        echo -e "Goodbye! \n"
        break                  
    
    #else if the guess is not an integer tell the user the guess is invalid
    elif ! [[ "$guess" =~ ^[0-9]+$ ]]; then                                         
        echo -e "\033[31mYour guess is not a valid number. Try again.\033[0m\n"     
    
    #else if the guess is not between 20 and 70 tell the user the guess is not within range
    elif [[ "$guess" -le 20 ]] || [[ "$guess" -ge 70 ]]; then                        
        echo -e "\033[31mYour guess is not within range.\033[0m Try again. \n"            
    
    #otherwise if the guess is valid 
    else                                                      
        if [[ -s "userguess.txt" ]]; then           #and the 'userguess' file is not empty
            grep -q $guess userguess.txt            #search the file for duplicate user input
            if [ $? -eq 0 ]; then                   #if the search returns true 
                echo -e "\033[31mYou've already"\
                "tried that number. Try again.\033[0m\n"  #tell the user to try again  
                continue                            #continue from start of loop         
            else
                echo $guess >> userguess.txt    #Else append guess to the userguess.txt file
                ((guesscnt++))                  #and increase the guess counter by 1
            fi    
        fi     
        
        if [ $guesscnt -eq 1 ]; then        #if the guesscount is 1
            singplu=guess                   #create a variable for 'guess' (singular)
        else
            singplu=guesses                 #otherwise a variable for 'guesses' (plural)
        fi

        if [ "$guess" -eq "$age" ]; then                           #if the guess equals the age
            echo -e "\033[36mCongratulations! I am $age.\033[0m"   #congratulate the user
            echo -e "You guessed the right age"\
            "in $guesscnt $singplu. \n"                     #tell them how many guesses it took
            break                                           #end the game

        
        elif [ "$guess" -lt "$age" ]; then                  #if the guess is less than age     
            echo -e "Your guess is too low. Try again. \n"  #tell the user it's too low         
        
        else [ "$guess" -gt "$age" ];                       #if the guess is greater than age
            echo -e "Your guess is too high. Try again. \n" #tell the user it's too high
        
        fi  
    
    fi  

done                                                        #game finished

