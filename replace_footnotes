#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [-supp] input_file.tex"
  exit 1
fi

use_supp=false

while getopts ":s" opt; do
  case "$opt" in
    s)
      use_supp=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

# Shift the options so that $1 refers to the input file
shift $((OPTIND - 1))

# Check if an input file is provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 [-f] input_file"
  exit 1
fi

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

output_file="${input_file%.tex}_modified.tex"
count=0

while IFS= read -r line; do
  # Check if the line contains \footnote{text}
  if [[ "$line" =~ .*\\footnote\{([^}]*)\}.* ]]; then
    # Increment the count
    ((count++))

    # Replace \footnote{text} with \cite{NoteX} or \cite{SuppNoteX} based on the flag
    if [ "$use_supp" = true ]; then
      line=$(echo "$line" | python3 line_replacement.py "$count" | sed "s/\\\\cite{Note$count}/\\\\cite{supp_Note$count}/")
      sed -i "s/{Note$count}/{supp_Note$count}/g" "$input_file_bbl"
    else
      line=$(echo "$line" | python3 line_replacement.py "$count")
    fi
  fi
  # Append the modified line to the output file
  echo "$line" >> "$output_file"

done < "$input_file"

rm "$input_file"
mv "$output_file" "$input_file"

echo "Replaced $count occurrences of \\footnote{text} with \\cite{NoteX} or \\cite{supp_NoteX} in $input_file."
