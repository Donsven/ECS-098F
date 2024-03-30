#!/usr/bin/bash

# The only command line argument is a file name
file_name=$1

# Boolean variable to track whether all fields are valid
passed=true

# Iterate over each line of the input file
while IFS= read -r line; do
    # Here's where you can use regex capture groups to extract the info from each line
    # You'll need to capture two pieces of data: the field name and the value of the field.
    # Put your regex with capture groups to the right of the =~ operator
    if  [[ $line =~ ^[[:space:]]*([^:]+)[[:space:]]*:[[:space:]]*(.+)[[:space:]]*$ ]]; then
        # Recall how to access text from regex capture groups
        # See slide 15 from the lecture
        field="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"

    else
        # If nothing could be extraced, then skip the line
        continue
    fi

    case $field in
        # You can follow this pattern for all other fields
        email) # Case where the field name is literally the string "email"
            # Same regex for email that we used in lecture
            pattern='^[[:alnum:]_#-]+@[[:alnum:]-]+\.[[:alnum:]]{2,4}$'
            ;;
        # Copy paste the previous example for every field, changing the email to the correct
        # field name and the pattern to the correct regex for said field

        first_name | last_name) # <String of alphabetic characters with no spaces>
            pattern='^[A-Za-z]+$'
            ;;

        phone_number) # <3 digits, followed by 1 hyphen, followed by 3 digits, followed by 1 hyphen, followed by 4 digits all with no spaces>
            pattern='^[0-9]{3}-[0-9]{3}-[0-9]{4}$'
            ;;

        street_number) # <1 to 5 digits>
            pattern='^[0-9]{1,5}$'
            ;;

        street_name | city) # <String of alphabetic characters>
            pattern='^[A-Za-z ]*[A-Za-z][A-Za-z ]*$'
            ;;

        apartment_number) # <1 to 4 digits or the empty string>
            pattern='^([0-9]{1,4}| )$'
            ;;

        state) # <2 capital letters>
            pattern='^[A-Z]{2}$'
            ;;

        zip) # <5 digits>
            pattern='^[0-9]{5}$'
            ;;

        card_number) # <16 digits with every with a hyphen between every 4 digits>
            pattern='^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$'
            ;;
        expiration_month) # <a number between 01 and 12>
            pattern='^(0[1-9]|1[0-2])$'
            ;;
        expiration_year) # <a number greater than or equal to 2021 but strictly less than 2030>
            pattern='^(202[1-9])$'
            ;;
        ccv) # <3 digits>
            pattern='^[0-9]{3}$'
            ;;

        *) # Case where there the field name didn't match anything
            continue
            ;;
    esac


    if ! [[ $value =~ $pattern ]]; then
        # Print out a message if the field isn't valid
        if [ -z "$value" ] || [[ "$value" =~ ^[[:space:]]+$ ]]; then
            echo "field $field with value  is not valid"
        else
            echo "field $field with value $value is not valid"
        fi
        passed=false
    fi
        
done < "$file_name"

# Print if all fields were valid
if [[ $passed = true ]]; then
    echo "purchase is valid"
    exit 0
fi

exit 1
