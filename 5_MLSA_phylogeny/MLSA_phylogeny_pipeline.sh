# Make directories
mkdir Reannotate_genomes/ # Make directory
mkdir Genome_files/ # Make directory
mkdir Proteomes/ # Make directory
mkdir MarkerScannerOutput/ # Make directory
mkdir MarkerScannerSingle/ # Make directory
mkdir MarkerScannerCounted/ # Make directory
mkdir MarkerScannerGood/ # Make directory
mkdir Mafft/ # Make directory
mkdir Trimal/ # Make directory
mkdir TrimalModified/ # Make directory
mkdir Phylogeny/ # Make directory

# Download proteomes
cat ../3_ANI_matrix/Input_files/Mesorhizobium.csv Input_files/Brucella.csv > Input_files/MLSA.csv
grep -v 'R7Astar' Input_files/Mesorhizobium.csv | grep -v 'R7ANSstar' > temp.txt # Get rid of redundant strains
mv temp.txt Input_files/Mesorhizobium.csv # Get rid of redundant strains
perl Scripts/parseGenomeList.pl Input_files/MLSA.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Fix the double __
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates
mv temp.txt Input_files/genomeList.txt # Rename the file
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # download the genomes of interest
cp ../2_Genome_annotation/Annotated_genomes/AR*/*.faa Genome_files/
cat Input_files/newGenomeList.txt Input_files/genomeList.txt > temp_1.txt # Concatenated new list with old one
sort -u -k1,1 temp_1.txt > temp_2.txt # Remove duplicates
mv temp_2.txt Input_files/genomeList.txt  # Rename file
rm temp_1.txt # Remove file

# Get the marker proteins
perl Scripts/switchNames.pl # Switch protein names
cat Proteomes/*.faa > combined_proteomes.faa # Combine the faa files into one file
rm Proteomes/*.faa # Remove unneeded files
perl Scripts/updateNumber.pl /datadisk1/Bioinformatics_programs/AMPHORA2/Scripts/MarkerScanner.pl # updates the number of sequences in the MarkerScanner.pl script
perl Scripts/MarkerScanner.pl -Bacteria combined_proteomes.faa # perform the MarkerScanner analysis
mv *.pep MarkerScannerOutput/ # Move output of MarkerScanner output directory
perl Scripts/extractSingle.pl # Extract proteins that are single copy
perl Scripts/countProteins.pl # Check that the proteins are found in enough genomes
perl Scripts/checkSpecies.pl # Check that in those genomes, the protein is found in single copy (probably redundant since the addition of extractSingle.pl)

# Run alignments and prepare concatenated alignment
perl Scripts/align_trim.pl # Run mafft on all individual sets of proteins
perl Scripts/modifyTrimAl.pl # Modify the trimAl output to prepare it for combining the alignments
perl Scripts/sortProteins.pl # Sort each of the trimAl output files that will be used for further analysis
perl Scripts/combineAlignments.pl > Phylogeny/MLSA_final_alignment.fasta # Concatenate the alignment files

# Prepare Phylogeny
cd Phylogeny/ # Change directory
raxmlHPC-HYBRID-AVX2 -T 28 -s MLSA_final_alignment.fasta -N 5 -n test_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
raxmlHPC-HYBRID-AVX2 -T 28 -s MLSA_final_alignment.fasta -N autoMRE -n MLSA_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALGF
cd ../ # Change directory
