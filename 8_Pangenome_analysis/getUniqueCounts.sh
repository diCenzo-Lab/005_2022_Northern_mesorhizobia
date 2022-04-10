grep $1 gene_presence_absence.csv | cut -f4 -d',' | grep '"1"' | wc -l

