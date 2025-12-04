#!/bin/bash

# Get the page
DATA=$(curl -s http://10.0.17.6/Assignment.html)

#######################################
# Extract ALL <td> values in the order they appear on the page
#######################################

TD_VALUES=$(echo "$DATA" | grep "<td>" | sed 's/<[^>]*>//g')

#######################################
# The first 10 <td> values = TEMP TABLE (5 rows × 2 columns)
#######################################
TEMP_VALUES=$(echo "$TD_VALUES" | head -n 10)

# Temperature numbers (1,3,5,7,9)
TEMP_COL=$(echo "$TEMP_VALUES" | sed -n '1~2p')

# Date-Time (2,4,6,8,10)
DATE_COL=$(echo "$TEMP_VALUES" | sed -n '2~2p')

#######################################
# The next 10 <td> values = PRESSURE TABLE (5 rows × 2 columns)
#######################################
PRESS_VALUES=$(echo "$TD_VALUES" | tail -n +11 | head -n 10)

# Pressure numbers (1,3,5,7,9)
PRESS_COL=$(echo "$PRESS_VALUES" | sed -n '1~2p')

#######################################
# Merge rows
#######################################

LINES=$(echo "$TEMP_COL" | wc -l)

for ((i=1; i<=$LINES; i++)); do

    P=$(echo "$PRESS_COL" | head -n $i | tail -n 1)
    T=$(echo "$TEMP_COL"  | head -n $i | tail -n 1)
    D=$(echo "$DATE_COL"  | head -n $i | tail -n 1)

    echo "$P $T $D"
done

