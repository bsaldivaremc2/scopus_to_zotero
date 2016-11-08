# scopus_to_zotero
This script allows to create a RDF file from a csv file that holds citation information exported from Scopus

In order to enable the conversion, you need to modify some things in your original csv file.
Your csv file needs to be separated by "|" (pipe sign) instead of ",". Also, the only fields allowed in the document
and in that order are:
*Authors|Title|Year|Source title|Volume|Issue|Page start|Page end|DOI|Link*

So, before using the script, execute
`head -n 1 your_file_from_scopus.csv`

and make sure that you get the same output.

## How to use
to execute the script you need to give as argument the csv file
`*./scopus_to_zotero.sh* your_file_from_scopus.csv`

Some other restrictions:
It only works with journals, not yet for conference papers.
