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

echo -e "\nCan you guess my age?\nMy name is Sue.\n\
I am aged between 20 and 70 years old. \n"              


while [ "$guess" != "$age" ]; do                                        #For as long as the guess does not equal the age,
    read -p "How old do you think I am (enter 'q' to quit): " guess     #ask the user to enter a guess or quit the game
#    echo $guess >> userguess.txt                                       ##########add the guess to the 'userguess.txt' file################
    
    if [ "$guess" == "q" ]; then                                        #if the user enters 'q' than quit the game and 
        echo -e "\033[33mGoodbye!\033[0m \n"
        break                                                           # break out of the loop
    
    elif ! [[ "$guess" =~ ^[0-9]+$ ]]; then                                         #if the guess is not an integer
        echo -e "\033[31mYour guess is not a valid number. Try again.\033[0m\n"     #tell the user their guess is invalid 
    
    elif [[ "$guess" -le 20 ]] || [[ "$guess" -ge 70 ]]; then                       #otherwise if the guess is not between 20 and 70 
        echo -e "\033[31mYour guess is not within range.\033[0m Try again. \n"      #tell the user their guess is not in range       
      
    #elif [ grep -q '$guess' userguess.txt ]; then                      #########check the 'userguess.txt' file for duplicated user input###########
    #    echo -e "You've already tried that number. Try again. \n"      #########tell the user if their guess has already been tried###############
     
    else                                                                
        ((guesscnt++))                      #otherwise if the guess is valid increase the guess count
        if [ $guesscnt -eq 1 ]; then        #if the guess count is equal to 1 use singular word 'guess' in the variable singplu
            singplu=guess               
        else
            singplu=guesses                 #otherwise use the plural word 'guesses' in the variable singplu
        fi

        if [ "$guess" -eq "$age" ]; then                            #if the guess is correct congratulate the user  
            echo -e "\033[33mCongratulations!\033[0m I am $age."\
            "You guessed the right age in $guesscnt $singplu. \n"   #tell the user how many attempts it took
            #cat "userguess.txt"                                    #######REMOVE#####################                   
            break                                                   #break out of the loop

        elif [ "$guess" -lt "$age" ]; then                          #if the guess is lower than age, 
            echo -e "Your guess is too low. Try again. \n"          #tell the user it's too low            

        else [ "$guess" -gt "$age" ];                               #otherwise if the guess is greater than age, 
            echo -e "Your guess is too high. Try again. \n"         #tell the user it's too high
        
        fi
    
    fi  

done

