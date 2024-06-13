#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file.tex"
    exit 1
fi

# Get input file name from command-line argument
input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file not found."
    exit 1
fi

input_file_bbl=$(echo "$input_file" | sed 's/\.tex$/.bbl/')

# Check if the input bbl file exists
if [ ! -f "$input_file_bbl" ]; then
    echo "Error: Input bbl file $input_file_bbl not found."
    exit 1
fi

# Find every occurrence of '\cite{text}' and process each citation
grep -o '\\cite{[^}]*}' "$input_file" | \
while IFS= read -r citation; do
    # Extract the text inside the curly braces
    text=$(echo "$citation" | sed -n 's/\\cite{\(.*\)}/\1/p')
    echo $text
    # Remove whitespaces from 'text'
    cleaned_text=$(echo "$text" | tr -d '[:space:]')

    # Split 'text' by ',' or ';', add 'supp_' to each piece and replace occurences in the bbl file
    elements=$(echo "$cleaned_text" | awk -F '[,;]' '{for (i=1; i<=NF; i++) print $i}')
    for el in $elements; do
        replacement="supp_$el"
        sed -i "s/{$el}/{$replacement}/g" "$input_file_bbl"
    done;

    # Split 'text' by ',' or ';' and add 'supp_' to each piece
    modified_text_comma=$(echo "$cleaned_text" | awk -F '[,]' '{for (i=1; i<=NF; i++) $i="supp_"$i","}1' | sed 's/,*$//')
    modified_text=$(echo "$modified_text_comma" | awk -F '[;]' '{for (i=1; i<=NF; i++) $i="supp_"$i";"}1' | sed 's/;*$//' |\
      sed 's/supp_supp_/supp_/g')
    echo $modified_text
    echo ""
    # Replace all occurrences of the original citation with the modified one
    sed -i "/$modified_text/ ! s/$text/$modified_text/g" "$input_file"
done

sed -i "s/bibliography{[^}]*}/input{${input_file_bbl}}/" "$input_file"

echo "Citations in $input_file have been replaced with leading 'supp_' and whitespaces removed. The bibliography has been input explicitly."
