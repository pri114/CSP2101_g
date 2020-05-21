#Priscilla Pitchen
#Student No. 943222

#!/bin/bash

RED='\033[00;31m'	    # Use ${RED} in the code
BLUE='\033[00;34m'	    # Use ${BLUE} in the code
NC='\033[00;0m'		    # Use ${NC} in the code

# Prompt the user to enter the text file to be formatted
read -p 'Enter the filename to be formatted: ' selfile

# If the file does not exist let the user know and exit 
if ! [ -f $selfile ]; then 
    echo -e "${RED}Error: ${NC}The file '$selfile' does not exist.\n"
    exit 0

# Otherwise if the file exists
else 
    # check it's a text file and search the file to ensure it's in the right format
    if [[ $selfile == *.txt ]]; then 
        grep -q -E 'Rec[0-9]+\,[0-9]+\,[0-9]+\,[0-9]+\,+[a-zA-Z]' $selfile  
        if [ $? -eq 0 ]; then                  # If true the text file can be formatted
            echo -e "\nFormatting...\n"             
            formfile="${selfile%.txt}_f.txt"   # create a new file and store in the variable 'formfile'

            # Parse out the lines from the selected file to sed
            # Delete the first line
            # Find every instance of the word 'Rec' gloablly and add the word 'Name: ' before it
            # Read every line, locate the first comma in each line and substitute with a tab and a heading. 
                # i.e. the first comma in each line will be replaced with a tab and the word 'Height'
                # the following comma (now the first) will be replaced with a tab and the word 'Width' and so forth 
                # until all four commas in each line have been replaced.
                sed -e '1d'\
                -e 's/Rec/Name: &/g'\
                -e 's/,/\tHeight: /'\
                -e 's/,/\tWidth: /'\
                -e 's/,/\tArea: /'\
                -e 's/,/\tColour: /' $selfile > $formfile # Write the formatted output to the newly created file stored in the variable 'formfile'

        # If the file is not the right format let the user know and exit
        else    
            echo "${RED}Error: ${NC}The file $selfile cannot be formatted.\n"
            exit 0
        fi
    
    # Otherwise if the file is not a text file let the user know and exit.
    else
        echo -e "${RED}Error: ${NC}The file '$selfile' is not a text file.\n" 
        exit 0
    fi  

fi

# Print contents of the output file formatted into a table with column titles in blue for readablity
# This is done by substituting each respective heading globally with the same heading printed in blue
cat $formfile | sed -e "s/Name:/`printf "${BLUE}Name:${NC}"`/g"\
                    -e "s/Height:/`printf "${BLUE}Height:${NC}"`/g"\
                    -e "s/Width:/`printf "${BLUE}Width:${NC}"`/g"\
                    -e "s/Area:/`printf "${BLUE}Area:${NC}"`/g"\
                    -e "s/Colour:/`printf "${BLUE}Colour:${NC}"`/g"
printf "\n\n"   

exit 0