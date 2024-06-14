#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 file1.tex file2.tex"
    exit 1
fi

# Get the input file names from command-line arguments
file1="$1"
file2="$2"

# Check if the input files exist
if [ ! -f "$file1" ]; then
    echo "Error: Input file $file1 not found."
    exit 1
fi

if [ ! -f "$file2" ]; then
    echo "Error: Input file $file2 not found."
    exit 1
fi

file1_noending=$(echo "$file1" | sed 's/\.tex$//')
file2_noending=$(echo "$file2" | sed 's/\.tex$//')

rm "./${file1_noending}.aux"
rm "./${file1_noending}.out"
rm "./${file1_noending}Notes.bib"
rm "./${file1_noending}.blg"
rm "./${file2_noending}.aux"
rm "./${file2_noending}.out"
rm "./${file2_noending}Notes.bib"
rm "./${file2_noending}.blg"
