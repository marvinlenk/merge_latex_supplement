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

pdflatex $file1 -draftmode
bibtex $file1_noending
pdflatex $file1 -draftmode
bibtex $file1_noending
pdflatex $file1 -draftmode
pdflatex $file1
pdflatex $file1

pdflatex $file2 -draftmode
bibtex $file2_noending
pdflatex $file2 -draftmode
bibtex $file2_noending
pdflatex $file2 -draftmode
pdflatex $file2
pdflatex $file2

# Create copies of the supplement with some modifications
./arxivsupp.sh $file2

file1_bbl=$(echo "$file1" | sed 's/\.tex$/.bbl/')

# Check if the input bbl file exists
if [ ! -f "$file1_bbl" ]; then
    echo "Error: Input bbl file $file1_bbl not found."
    exit 1
fi

file1_arxiv="${file1_noending}_arXiv.tex"

cp "$file1" "$file1_arxiv"
cp "$file1_bbl" "${file1_noending}_arXiv.bbl"

# modify the copied main to accept the supplement at the end
sed -i "s/bibliography{[^}]*}/input{${file1_noending}_arXiv.bbl}/" "$file1_arxiv"
sed -i "s/end{document}/input{${file2_noending}_arXiv.tex}\n/" "$file1_arxiv"

./replace_citations.sh "$file1_arxiv"
./replace_footnotes.sh "$file1_arxiv"

# Remove compile files of main and supplement
rm "./${file1_noending}.aux"
rm "./${file1_noending}.out"
rm "./${file1_noending}Notes.bib"
rm "./${file1_noending}.blg"
rm "./${file2_noending}.aux"
rm "./${file2_noending}.out"
rm "./${file2_noending}Notes.bib"
rm "./${file2_noending}.blg"

# Compile the final files
pdflatex $file1_arxiv -draftmode
pdflatex $file1_arxiv
pdflatex $file1_arxiv

# And remove the unneeded compilation files.
rm "./${file1_noending}_arXiv.aux"
rm "./${file1_noending}_arXiv.out"
rm "./${file1_noending}_arXivNotes.bib"

echo "Please check if $file1 $file2 and $file1_arxiv give the desired PDF output."

exit 0
