#!/bin/bash

guesscnt=0
guess=""
age="35"

#Tell the user what they are required to do
echo -e "Can you guess my age?\nMy name is Sue. \nI like to knit and walking on the beach. \nI am aged between 20 and 70 years old.\n "

#For as long as the guess does not equal the age ask the user to enter a guess
while [ "$guess" != "$age" ]; do
    read -p "How old do you think I am (enter 'q' to quit): " guess
    
    #if the user enters 'q' than quit the game
    if [ "$guess" == "q" ]; then 
        echo 'Game over. '
        break
    
    #if the guess is not an integer tell the user their guess is invalid and to try again
    elif ! [[ "$guess" =~ ^[0-9]+$ ]]; then 
        echo 'Your guess is not valid. Try again. '
    #otherwise if not in range tell the user to try again
    elif [[ "$guess" -le 20 ]] || [[ "$guess" -ge 70 ]]; then
        echo 'Your guess is not within range. Try again. '  
    #otherwise if the guess is valid increase the guess count
    else
        ((guesscnt++))
        
        #if the guess is correct, congratulate the user
        if [ "$guess" -eq "$age" ]; then
            echo 'Congratulations! I am $age. You guessed the right age after $guesscnt guesses. '
            break
        #if the guess is lower than age, tell the user it's too low
        elif [ "$guess" -lt "$age" ]; then
            echo 'Your guess is too low. Try again. '
        #otherwise if the guess is greater than age, tell the user it's too high 
        else [ "$guess" -gt "$age" ];
            echo "Your guess ts too high. Try again. "
        
        fi
    
    fi
done

