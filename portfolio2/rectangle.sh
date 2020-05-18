#Priscilla Pitchen
#Student No. 943222

#!/bin/bash

RED='\033[00;31m'	    # Use ${RED} in the code
BLUE='\033[00;34m'	    # Use ${BLUE} in the code
NC='\033[00;0m'		    # Use ${NC} in the code

# Prompt the user to enter the text file to be formatted
read -p 'Enter the name of file to be formatted: ' selfile

# If the file does not exist let the user know and exit 
if ! [ -f $selfile ]; then 
    echo -e "${RED}Error: ${NC}The file '$selfile' does not exist.\n"
    exit 0

# Otherwise if the file exists
else 
    # test to see if it's a text file
    if [[ $selfile == *.txt ]]; then 
        grep -q -E 'Rec[0-9]+\,[0-9]+\,[0-9]+\,[0-9]+\,+[a-zA-Z]' $selfile     # Search the file to ensure it's in the right format
        if [ $? -eq 0 ]; then                                               # If true
            echo -e "\nFormatting...\n"                                     
            formfile="${selfile%.txt}_f.txt"                                # create a new file and store in the variable 'formfile 

            # Parse out the lines from the selected file deleting the first line and insert headings at start of each column
            sed -e '1d'\
                -e 's/Rec/Name: &/g'\
                -e 's/,/\tHeight: /'\
                -e 's/,/\tWidth: /'\
                -e 's/,/\tArea: /'\
                -e 's/,/\tColour: /' $selfile > $formfile      # Write the formatted results to the newly created file

        # If the file is not the right format let the user know and exit
        else    
            echo "The file $selfile cannot be formatted.\n"
            exit 0
        fi
    
    # Otherwise if the file is not a text file let the user know and exit.
    else
        echo -e "${RED}Error: ${NC}The file '$selfile' is not a text file.\n" 
        exit 0
    fi  

fi

# Print contents of the file into a table with column titles in blue for readablity
cat $formfile | sed -e "s/Name:/`printf "${BLUE}Name:${NC}"`/g"\
                    -e "s/Height:/`printf "${BLUE}Height:${NC}"`/g"\
                    -e "s/Width:/`printf "${BLUE}Width:${NC}"`/g"\
                    -e "s/Area:/`printf "${BLUE}Area:${NC}"`/g"\
                    -e "s/Colour:/`printf "${BLUE}Colour:${NC}"`/g"
printf "\n\n"   

exit 0