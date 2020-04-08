#Priscilla Pitchen
#Student No. 943222

#!/bin/bash

#age="$(( $RANDOM % 50 + 21 ))"      #create a variable "age" that will produce a random number between 20 and 70
age=35
guess=""                            #create an empty varibale "guess"
guesscnt=0                          #set guesscount to zero


if ! [ -f "userguess.txt" ]; then   #if a file does not already exist
    touch userguess.txt             #create an empty file to hold the user's guesses
else
    echo "" >| userguess.txt        #otherwise if the file already exists overwrite it with an empty file         
fi

#Tell the user to guess an age and the parameters
echo -e "\nCan you guess my age?\nMy name is Sue.\nI am aged between 20 and 70 years old. \n"              

#For as long as the guess does not equal the age, ask the user to enter a guess or quit the game
while [ "$guess" != "$age" ]; do                                        
    read -p "How old do you think I am (enter 'q' to quit): " guess     
#    echo $guess >> userguess.txt                                       ##########add the guess to the 'userguess.txt' file################
    
    #if the user enters 'q' than quit the game and end the loop
    if [ "$guess" == "q" ]; then 
        echo -e "\033[33mGoodbye!\033[0m \n"
        break                  
    
    #if the guess is not an integer tell the user the guess is invalid
    elif ! [[ "$guess" =~ ^[0-9]+$ ]]; then                                         
        echo -e "\033[31mYour guess is not a valid number. Try again.\033[0m\n"     
    
    #otherwise if the guess is not between 20 and 70 tell the user the guess it not within range
    elif [[ "$guess" -le 20 ]] || [[ "$guess" -ge 70 ]]; then                        
        echo -e "\033[31mYour guess is not within range.\033[0m Try again. \n"            
      
    #elif [ grep -q '$guess' userguess.txt ]; then                      #########check the 'userguess.txt' file for duplicated user input###########
    #    echo -e "You've already tried that number. Try again. \n"      #########tell the user if their guess has already been tried###############

    #otherwise if the guess is valid increase the guess count and 
    #set the variable singplu based on the tally of guesses
    else                                                                
        ((guesscnt++))                      
        if [ $guesscnt -eq 1 ]; then        
            singplu=guess               
        else
            singplu=guesses                 
        fi

        #if the guess is correct congratulate the user and tell them how many guesses it took
        if [ "$guess" -eq "$age" ]; then                              
            echo -e "\033[33mCongratulations!\033[0m I am $age."\
            "You guessed the right age in $guesscnt $singplu. \n"   
            #cat "userguess.txt"                                    #######REMOVE#####################                   
            break                                                   

        #otherwise if the guess is lower than age, tell the user it's too low
        elif [ "$guess" -lt "$age" ]; then                           
            echo -e "Your guess is too low. Try again. \n"         
        #otherwise if the guess is greater than age, tell the user it's too high
        else [ "$guess" -gt "$age" ];
            echo -e "Your guess is too high. Try again. \n" 
        
        fi
    
    fi  

done

