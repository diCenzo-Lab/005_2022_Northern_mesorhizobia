## Prepare necessary directories
mkdir Output/
mkdir intermediaryFiles/
mkdir Genome_files/ # Make directory

# Download the Mesorhizobium genomes
cat Input_files/Complete_chromosome.csv Input_files/Representative.csv > Input_files/Mesorhizobium.csv # Combine files
grep -v 'R7Astar' Input_files/Mesorhizobium.csv | grep -v 'R7ANSstar' > temp.txt # Get rid of redundant strains
mv temp.txt Input_files/Mesorhizobium.csv # Get rid of redundant strains
perl Scripts/parseGenomeList.pl Input_files/Mesorhizobium.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Remove the period after sp
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates
mv temp.txt Input_files/genomeList.txt # Rename the file
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # Download the genomes of interest
cp ../2_Genome_annotation/Annotated_genomes/AR*/*.fna Genome_files/ # Get the new genomes
cat Input_files/newGenomeList.txt Input_files/genomeList.txt > temp_1.txt # Concatenated new list with old one
sort -u -k1,1 temp_1.txt > temp_2.txt # Remove duplicates
mv temp_2.txt Input_files/genomeList.txt  # Rename file
rm temp_1.txt # Remove file

## Run fastANI
find Genome_files/*.fna > intermediaryFiles/genomePaths.txt # Get the genome paths
fastANI --ql intermediaryFiles/genomePaths.txt --rl intermediaryFiles/genomePaths.txt -o Output/fastani_output.txt # Run fastANI

## Parse fastANI output
sort -k1,1 -k2,2 Output/fastani_output.txt > Output/fastani_output_sorted_1.txt # Sort the file by first column then by second column
sort -k2,2 -k1,1 Output/fastani_output.txt > Output/fastani_output_sorted_2.txt # Sort the file by second column then by first column
cut -f 1,2,3 Output/fastani_output_sorted_1.txt > temp.txt # Get the relevant columns of the first sorted file
cut -f 3 Output/fastani_output_sorted_2.txt > temp2.txt # Get the relevant columns of the second sorted file
paste -d ' ' temp.txt temp2.txt > Output/fastani_output_twoWay.txt # Combine the relevant columns
rm temp* # remove the temporary files
perl Scripts/prepareANImatrix.pl > Output/ANI_matrix.txt # make a two-way ANI matrix from the fastANI output
