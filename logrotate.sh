#!/bin/sh

set -e

CURRENT_LOG_FILE=$1
HOME_DIR="${CURRENT_LOG_FILE%/*}"
PREVIOUS_DAY_LOG_FILE="$CURRENT_LOG_FILE.1"
OLDEST_FILE="$CURRENT_LOG_FILE.$2.gz"



if [ -f $OLDEST_FILE ]; then
    rm $OLDEST_FILE
else 
    echo "$OLDEST_FILE does not exist"
fi

for file in $(find $HOME_DIR -name '*.gz'  -mindepth 1 -maxdepth 1 | sort -rn); do
    file_name_without_ex="${file%.*}"
    second_ex="${file_name_without_ex##*.}"
    file_name_without_second_ex="${file_name_without_ex%.*}"
    incremented_second_ex=$(echo "$second_ex" | tr "0-9a-z" "1-9a-z_")
    
    if [ $incremented_second_ex -gt $2 ]; then
        rm $file
    else
        new_file_name="$file_name_without_second_ex.$incremented_second_ex.gz"
        mv $file $new_file_name
    fi
    
done


if [ -f $PREVIOUS_DAY_LOG_FILE ]; then
    gzip $PREVIOUS_DAY_LOG_FILE
else
    echo "$PREVIOUS_DAY_LOG_FILE does not exist"
fi


if [ -f $CURRENT_LOG_FILE ]; then
    mv $CURRENT_LOG_FILE "$CURRENT_LOG_FILE.1"
else
    echo "$CURRENT_LOG_FILE does not exist"
fi

