#Priscilla Pitchen
#Student No. 943222

#!/bin/bash

#////Set variables for age, guess and guess count:

age="$(( $RANDOM % 50 + 21 ))"     #generate a random number and store in a variable
guess=""                           #create an empty variable to store user guesses
guesscnt=0                         #create a counter for the guesses and set to zero


#////Introduction to game and instructions:

#Tell the user what they need to do
echo -e "\nCan you guess my age?\nMy name is Sue.\nI am aged between 20 and 70 years old. \n"              

#////Create an endless loop to capture and test user input. Ensure there is an exit strategy

#For as long as the guess does not equal age, ask the user to enter a guess or quit the game
while [ "$guess" != "$age" ]; do                                        
    read -p "How old do you think I am (enter 'q' to quit): " guess     
        
    #if the user enters 'q' than end the game
    if [ "$guess" == "q" ]; then 
        echo -e "Goodbye! \n"
        break                  
    
    #else if the guess is not an integer tell the user the guess is invalid
    elif ! [[ "$guess" =~ ^[0-9]+$ ]]; then                                         
        echo -e "\033[31mYour guess is not a valid number.\033[0m Try again.\n"     
    
    #else if the guess is not between 20 and 70 tell the user it's out of range
    elif [[ "$guess" -le 20 ]] || [[ "$guess" -ge 70 ]]; then                        
        echo -e "\033[31mYour guess is not within range.\033[0m Try again.\n"            
    
 #////Once all invalid guesses are ruled out check for ‘userguess’ file, duplication & add guess to count: 

    #if input is a valid guess
    else                                                      
        if [[ -f "userguess.txt" ]]; then                                   #if the 'userguess' file exists and
            if [[ -s "userguess.txt" ]] && [[ $guesscnt -ge 1 ]]; then      #if file is not empty and count at least 1
                grep -q $guess userguess.txt                                #search the file for duplicate user input

                if [ $? -eq 0 ]; then                                                           #if search returns true 
                    echo -e "\033[31mYou've already tried that number.\033[0m Try again.\n"     #tell the user to try again     
                    continue                                                                    #and go back to start of loop
                else                                        #if search returns false
                    echo $guess >> userguess.txt            #append guess to 'userguess' file
                    ((guesscnt++))                          #and increase the guess count by 1 
                fi

            else                                #if the count is zero (i.e. a new game)
                echo $guess > userguess.txt    #overwrite guess to 'userguess' file
                ((guesscnt++))                  #and increase the guess count by 1                  
            fi

        else                                    #else if file does not already exist
            echo "$guess" >| userguess.txt      #create a new file and add guess
            ((guesscnt++))                      #and increase the guess count by 1 
        fi     

#////Creating a variable to hold the word guess or guesses based on guess count:

        if [ $guesscnt -eq 1 ]; then            #if the guesscount is 1
            singplu=guess                       #create a variable for 'guess' (singular)
        else
            singplu=guesses                     #otherwise a variable for 'guesses' (plural)
        fi

#////Determining if the guess is correct, too low or too high:

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

done                                                #game over

