#Priscilla Pitchen
#Student No. 943222

#!/bin/bash


# Store ECU webiste URL in the variable 'url'
url=https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152

# Download website data and pipe output to the sed command. Parse out all lines that contain an image (-n disables auto print and -r removes whitespace )
    # Substitute unwanted characters at the beginning and end of each line and print the new pattern after substitution. 
    # Store output in the 'images.txt' file for later use throughout the script
curl -s $url | sed -n -r '/<img/ {    
    s/.{14}//
    s/.{17}$//
    p
    }' > webdata.txt

# Create variables for colour to be used when outputting information to the screen
RED='\033[00;31m'	 	# Use ${RED} in the code
CYAN='\033[00;36m'		# Use ${CYAN} in the code
BLUE='\033[00;34m'		# Use ${BLUE} in the code
NC='\033[00;0m'		    # Use ${NC} in the code


## FUNCTIONS: /////

# The exit option function gives the user a choice to end or continue the program at various points throughout the script. The argument '$1' will
    # be a message printed to the screen, followed by the option to exit or continue. If input is 'x' (case insensitive) Goodbye is printed to
    # the screen and the program will end. Otherwise the function will return '0' (true)
exitopt() {
    local input
    echo -e "$1"
        echo -e "Press any key to continue or [x] to exit." 
        read input   
        if [[ $input = [xX] ]]; then
            echo 'Goodbye!' && exit 1
        else
           return 0
        fi
}

# The download function is used to download the requested file(s) by the user
    # The current working directory is stored in the variable 'rdir' and local variables created for 'rdir', 'input', 'image number' and 'folder'. 
    # When the function is called the user is asked where to save the downloads and the response is stored in the variable 'folder'
download() {
    printf "\n"
    local rdir local input local imageNum local folder
    rdir=$(pwd)
    read -p "Enter a folder name where the image(s) will be downloaded and saved: " folder
    printf "\n"
    
    # Start a for loop for every 'image url' saved in the text file argument '$1'. Pipe the output of the variable 'imgurl' into the sed command.
        # Everything up to '152/' and '.jpg' is replaced with nothing (leaving just the image number stored in the variable)
    for imgurl in $( cat $1 ); do
    imageNum=$( echo $imgurl | sed -e "s/.*152\///; s/\.jpg//" )        
        
        # If the file doesn't exist in the chosen folder run 'wget' to download the image from the server. Gather output into a file 'urlout.txt' for
            # later use (-o) and direct the download content to a specific directory path (-P).
        if ! [ -f "${rtdir}${folder}/$imageNum.jpg" ]; then
            wget -o urlout.txt $imgurl -P $folder
            
            # Create a variable 'filename'. Use sed to search 'urlout.txt' file for the line containing the word 'Saving'. Substitute all characters from
                # the beginning of the line to the first forward slash with nothing. Substitute the last character with nothing and print after substitution.
                # Input is from the 'urlout.txt' file and output is stored in the variable 'filename'
            filename=$( sed -n '/Saving/ { s/.*\///; s/.$// p }' urlout.txt )
            
            # Create a variable 'filesize'. Pipe contents from the 'urlout.txt' file to the the sed command. Parse out the line with the word 'Length'
                # and pipe to the awk command to print the second field divided by 1,000 as a float to two decimal places.
                # Echo a message to the user with blue text and information from the output file saved when downloading.
            filesize=$( cat urlout.txt | sed -n '/Length/ p' | awk '{printf "%.2f", $2/1000}' )
            echo -e "Downloading ${BLUE}$imageNum${NC}, with the file name ${BLUE}$filename${NC}, with a file size of ${BLUE}$filesize KB${NC}....File Download Complete."
        
        # If the file already exists let the user know and ask for confirmation to overwrite the file or proceed
        else    
            echo -e "The file ${rtdir}${folder}/$imageNum.jpg already exists. Press any key to continue or [o] to overwrite: "
            read input
            
            # If the user inputs 'o' (case insensitive) proceed to download image from the server with wget command. 
                # Gather output into a file 'urlout.txt' for later use (-o)and save the file with a given name (-O). 
                # Move the downloaded file to the folder selected by the user. 
                # Create the variables filename and filesize as in previous step and echo a message to the user with download information
            if [[ "$input" = [oO] ]]; then
                wget -o urlout.txt $imgurl -O $imageNum.jpg
                mv $imageNum.jpg $folder
                filename=$( sed -n '/Saving/ { s/.* //; s/^.//; s/.$// p }' urlout.txt )
                filesize=$( cat urlout.txt | sed -n '/Length/ p' | awk '{printf "%.2f", $2/1000}' )
                echo -e "Downloading ${BLUE}$imageNum${NC}, with the file name ${BLUE}$filename${NC}, with a file size of ${BLUE}$filesize KB${NC}....File Download Complete."             
            
            # If the user presses any key continue to the next iteration of the loop if applicable
            else
                continue
            fi 
        fi
    done
    printf "\n"
}

## SCRIPT: /////

# While true the program will continue in a loop until the user chooses to exit
while true; do

    # Count (-c) the number of images (.jpg) stored in the file 'webdata.txt' and display the number of images and download options available
    imgCount="`grep -c '.jpg' webdata.txt`"                    
    echo -e "\nThe ECU Website Media Gallery has ${CYAN}$imgCount thumbnail images${NC} available for download:\n"      

    # Pipe the output of the 'webdata.txt' file to sed. Substitue everything up to '152/' and '.jpg' with nothing, leaving just the image numbers. 
        # Pipe output of sed to awk to print all image numbers in a table-like format evenly spaced (14 spaces) apart.
    cat webdata.txt | sed -n 's/.*152\///; s/.jpg//p' | awk '{printf "%-14s", $0} END {printf "\n\n"}'
    echo -e "Images can be downloaded in the following ways:\n
        \r1. Download a specific thumbnail
        \r2. Download ALL thumbnails
        \r3. Download images in a range (by the last 4 digits of the file name), e.g. all images between 1558 and 1569
        \r4. Download a specified number of randomly chosen images\n"

    # Start a loop - while true ask the user to choose from one of the download options and store the selected number response in the variable 'selNum'
    while true; do                      
        read -p "Choose from the download options above by entering a number from 1-4: " selNum 
        # If the 'selNum' variable contains no data call the 'exitopt' function
        if [[ -z "$selNum" ]]; then                          
            exitopt "${RED}Invalid Entry.${NC} Input required. Try again."         
        
        # If the 'selNum' variable is an integer between 1 and 4 inclusive break out of the loop
        elif [[ "$selNum" =~ ^[1-4]$ ]]; then             
        break                                                   
        
        # Otherwise if the 'selNum' variable is not empty and not an integer call the 'exitopt' function 
        else
            exitopt "${RED}Invalid Entry.${NC} ${BLUE}$selNum${NC} is not a valid number. Try again."
        fi
    done

    # Create a case statment for download options
    case $selNum in

    ## Option 1: /// Download a SPECIFIC thumbnail image
    1)                                                                              
    # Start a loop - while true prompt the user to enter the image number to download
    while true; do                                                                  
        read -p "Enter the thumbnail image number you want to download: " imageNum  
        
        # If the 'imagelNum' variable contains no data call the 'exitopt' function
        if [[ -z $imageNum ]]; then                                            
            exitopt "${RED}Invalid Entry.${NC} Input required. Try again." 
        
        # If the 'imageNum' variable doesn't contain 'DSC' at the start preceded by five digits call the 'exitopt' function
        elif ! [[ $imageNum =~ ^DSC[0-9]{5}$ ]]; then
            exitopt "${RED}Invalid Entry.${NC} ${BLUE}$imageNum${NC} is not a valid image number. Try again."                                               
        
        # If the 'imageNum' variable is the right format quietly (-q) search for the image number in the 'webdata.txt' file 
        else
            grep -q $imageNum webdata.txt                    
            
            #If the grep search returns a match (true) pipe the contents of the 'webdata.txt' file to the sed command. Parse out the lines matching  
                # the 'imageNum' variable and print output to the 'images.txt' file. Call the download function with the 'images.txt' file as
                # argument '$1' and break out of loop
            if [ $? -eq 0 ]; then                           
                cat webdata.txt | sed -n "/$imageNum/p" > images.txt
                download images.txt           
                break
            
            # If the grep search returns false (1) call the 'exitopt' function
            else
                exitopt "${RED}Invalid Entry.${NC} The thumbnail ${BLUE}$imageNum${NC} does not exist. Try again."          
            fi
        fi
    done

    # When the selected image has been downloaded and saved call the exitopt function to return to start or exit the program
    exitopt "\n${BLUE}Downloading Finished.${NC}"
    ;;

    ## Option 2: /// Download ALL thumbnail images
    2)
    # Call the download function with the 'webdata.txt file' (containing all urls)
    download webdata.txt
    
    # When downloading of all images is complete call the exitopt function to return to start or exit the program
    exitopt "\n${BLUE}Downloading Finished.${NC}"
    ;;

    ## Option 3: /// Download images in a RANGE (by last 4 digits of the file name)
    3)
    # Set a variable for word 'lowest' & 'highest' and create an array to hold the variables. Create the rangenum.txt file (>| overwrites 
        # with a blank file if it already exists) and create a variable for the lowest limit 'lowLim' and set to zero
    low="LOWEST"
    high="HIGHEST"
    range=" $low $high " 
    >| rangenum.txt
    lowLim=0

        # Start a loop for every limit in the range (low/high) and while true prompt the user to select a number, storing response in the variable 'selNum'
        for limit in $range; do   
            while true; do
                read -p "Enter the last four digits of the $limit image number in the range: " selLim
                
                # If the variable 'selNum' is empty call the 'exitopt' function
                if [[ -z $selLim ]]; then
                    exitopt "${RED}Invalid Entry.${NC} Input required. Try again." 
                
                # If the 'selNum' variable doesn't contain a four digit integer call the 'exitopt' function
                elif ! [[ $selLim =~ ^[0-9]{4}$ ]]; then                                 
                    exitopt "${RED}Invalid Entry.${NC} ${BLUE}$selLim${NC} is not a valid four digit number. Try again."
                
                # If the 'selNum' variable is the right format quietly (-q) search for the selected image number in the 'webdata.txt' file 
                else
                    grep -q DSC0${selLim} webdata.txt
                    
                    # If the grep search returns false (1) call the 'exitopt' function
                    if ! [ $? -eq 0 ]; then                                            
                        exitopt "${RED}Invalid Entry.${NC} Thumbnail image ${BLUE}DSC0${selLim}${NC} does not exist. Try again."    
                    
                    # If the grep search returns true (0), test if 'lowlim' is not less than the current 'selLim'. If true call exitopt function
                    elif ! [[ $lowLim < $selLim ]]; then
                        exitopt "${RED}Invalid Entry.${NC} ${BLUE}DSC0${selLim}${NC} is out of range (Input needs to be greater than the lower limit). Try again."                             
                    
                    # If 'lowlim' saved is less than the current 'selLim', echo output to the 'rangenum.txt file and break out of the loop
                    else
                        lowLim=$selLim
                        echo DSC0${selLim} >> rangenum.txt
                        break    
                    fi
                fi
            done    
        done
    
    #Extract the contents of the 'rangenum.txt' file to store each image number in it's own variable. Using awk set the field seperator to a new line and
        # the record seperator to an empty space (file to be read as one record). Print the first field '$1' and store in the variable 'lowNum' and print the
        # second field '$2' in the variable 'highNum'
    lowNum=$(awk 'BEGIN { FS="\n"; RS=""} END {print $1}' ./rangenum.txt)
    highNum=$(awk 'BEGIN { FS="\n"; RS=""} END {print $2}' ./rangenum.txt)
    
    # Use sed to search for lines with matching patterns (-n disables auto print). Delete all lines from the first line to the line before the matching 
        # pattern 'lowNum'. Print all lines from the line with the matching pattern 'highNum' to the end of the file. Print the line with 'hihgNum'. Input from 
        # 'webdata.txt' file (containing all urls) and output stored in the 'images.txt' file. 
        # Call the download function with the 'images.txt file' (containing only urls in range) as the first argument '$1'
    sed -n '/'$lowNum'/,$!d; /'$highNum'/,$!p; /'$highNum'/p' webdata.txt > images.txt
    download images.txt

    # When downloading images within the selected range is complete, call the exitopt function to return to start or exit the program
    exitopt "\n${BLUE}Downloading Finished.${NC}"
    ;;

    ## Option 4: /// Download a specified number of RANDOM images
    4)
    # Start a loop and while true prompt the user to enter a number of images to download. Store the response in the variable 'randNum'
    while true; do
        read -p "Enter the number of images less than $imgCount that will be randomly selected for download: " randNum
        
        # if 'randNum' is an integer and less than the max number of images inthe variable 'imgCount' than break out of the loop
        if [[ $randNum =~ ^[0-9]+$ ]] && [[ $randNum -lt $imgCount ]]; then      
            break
        
        # if the variable 'randNum' is empty call the exitopt function
        elif [[ -z $randNum ]]; then
            exitopt "Input required. Try again"
        
        # If no conditions are met call the exitopt function
        else 
            exitopt "${RED}Invalid Entry.${NC} ${BLUE}$randNum${NC} is not a valid number. Try again."
        fi
    done

    # Pipe the output of the 'webdata.txt' file to sed. Shuffle contents of the file. Parse out lines from the beginning of the file to
        # the $randNum' line and print output to 'images.txt' file. Call the download function with the 'images.txt file' (containing a 
        # selected no. of random urls) as the first argument '$1'
    cat webdata.txt | shuf | sed -n '1,'$randNum'p' > images.txt
    download images.txt
    
    # When downloading of selected number of random images is complete call the exitopt function to return to start or exit the program
    exitopt "\n${BLUE}Downloading Finished.${NC}"
    ;;

    esac

done

exit 0