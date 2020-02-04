#!/bin/sh

# output_app.log
set -e

HOME_DIR=$1
CURRENT_LOG_FILE="$HOME_DIR/$2"
PREVIOUS_DAY_LOG_FILE="$HOME_DIR/$3"
OLDEST_FILE="$HOME_DIR/$4"


# OLDEST_FILE=output_app.log.5.gz
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
    new_file_name="$file_name_without_second_ex.$incremented_second_ex.gz"
    mv $file $new_file_name
done


# PREVIOUS_DAY_LOG_FILE=output_app.log.1
if [ -f $PREVIOUS_DAY_LOG_FILE ]; then
    gzip $PREVIOUS_DAY_LOG_FILE
else
    echo "$PREVIOUS_DAY_LOG_FILE does not exist"
fi

# CURRENT_LOG_FILE=output_app.log
if [ -f $CURRENT_LOG_FILE ]; then
    mv $CURRENT_LOG_FILE "$CURRENT_LOG_FILE.1"
else
    echo "$CURRENT_LOG_FILE does not exist"
fi



# for i in $(find . -name '*.log.*' -not -name '*.gz'  -mindepth 1 -maxdepth 1); do
#     gzip $i
# done
