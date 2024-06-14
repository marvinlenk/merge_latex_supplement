# merge_latex_supplement
A collection of scripts that together give the functionality to merge two .tex files into one larger one with two separate bibliographies.

### mergetex_arxiv.sh
``mergetex_arxiv.sh file1.tex file2.tex``

This is the main script; it first compiles both files individually, then calls other scripts to replace the citations accordingly, appends ``file2.tex`` to ``file1.tex``, and compiles the final merged result.


### arxivsup.sh
``arxivsup.sh file2.tex``

This script is called on ``file2.tex`` of the original ``mergetx_arxiv.sh`` call. It creates a new texfile with an added ``\clearpage`` at the top and resets counters to zero. Finally, the scripts ``replace_citations.sh`` and ``replace_footnotes.sh`` are invoked on the copy.


### replace_citations.sh
``replace_citations.sh``

A script that finds all occurrences of ``\cite{...}`` and adds a leading ``supp_...`` to each entry. It also replaces the ``\bibliography{...}`` command with an explicit ``\input{bibfile.bbl}``.


### replace_footnotes.sh
``replace_footnotes.sh``

A script that finds all occurrences of ``\footnote{...}`` and replaces it with ``\cite{NoteX}``, where ``X`` is an integer counter. It takes an additional flag ``-s`` that determines if a leading ``supp_`` should be added to ``NoteX``.


### line_replacement.py
``line_replacement.py``

A Python script that takes care of the ``\footnote{...}`` detection, including additional ``{...}`` inside the footnote.


### cleanup.sh tile1.tex file2.tex
``cleanup.sh tile1.tex file2.tex``

Removes all auxiliary files from ``pdflatex`` and ``bibtex`` runs on ``file1.tex`` and ``file2.tex``.
