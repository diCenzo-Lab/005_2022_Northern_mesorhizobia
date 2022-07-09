# Prepare directories
mkdir Input_files/ # Make directory
mkdir Genome_files/ # Make directory
mkdir hmmDatabaseFiles/ # Make directory
mkdir HMMsearch/ # Make directory
mkdir HMMsearchParsed/ # Make directory
mkdir HMMsearchHits/ # Make directory
mkdir HMMscan/ # Make directory
mkdir HMMscanParsed/ # Make directory
mkdir HMMscanTop/ # Make directory
mkdir HMMscanTopLists/ # Make directory
mkdir SymbioticProteins/ # Make directory
mkdir Phylogenies/
mkdir NCBI_analysis/
mkdir NCBI_analysis/NodA/
mkdir NCBI_analysis/NodB/
mkdir NCBI_analysis/NodC/
mkdir NCBI_analysis/Genomes/

# Get protein sequences
cp ../3_ANI_matrix/Input_files/Mesorhizobium.csv Input_files/
grep -v 'R7Astar' Input_files/Mesorhizobium.csv | grep -v 'R7ANSstar' > temp.txt # Get rid of redundant strains
mv temp.txt Input_files/Mesorhizobium.csv # Get rid of redundant strains
perl Scripts/parseGenomeList.pl Input_files/Mesorhizobium.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Remove the period after sp
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates
mv temp.txt Input_files/genomeList.txt # Rename the file
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # Download the genomes of interest
cp ../2_Genome_annotation/Annotated_genomes/AR02/Mesorhizobium_sp_AR02.gbk Genome_files/Mesorhizobium_sp_AR02.gbff # Get the new genomes
cp ../2_Genome_annotation/Annotated_genomes/AR07/Mesorhizobium_sp_AR07.gbk Genome_files/Mesorhizobium_sp_AR07.gbff # Get the new genomes
cp ../2_Genome_annotation/Annotated_genomes/AR10/Mesorhizobium_sp_AR10.gbk Genome_files/Mesorhizobium_sp_AR10.gbff # Get the new genomes
cat ../3_ANI_matrix/Input_files/newGenomeList.txt Input_files/genomeList.txt > temp_1.txt # Concatenated new list with old one
sort -u -k1,1 temp_1.txt > temp_2.txt # Remove duplicates
mv temp_2.txt Input_files/genomeList.txt  # Rename file
rm temp_1.txt # Remove file
perl Scripts/extractFaaFromGBFF.pl # Make faa files from the GenBank files
perl Scripts/modifyFasta.pl combined_proteomes_HMM.faa > combined_proteomes_HMM_modified.faa # Modify the fasta file for easy extraction

# Download HMM databases
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz # get the Pfam HMM files
wget https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMs_15.0_HMM.LIB.gz # get the TIGRFAM HMM files
gunzip Pfam-A.hmm.gz # unzip the Pfam files
gunzip TIGRFAMs_15.0_HMM.LIB.gz # unzip the TIGRFAM files
mv Pfam-A.hmm hmmDatabaseFiles/Pfam-A.hmm # move the Pfam files
mv TIGRFAMs_15.0_HMM.LIB hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB # move the TIGRFAM files
hmmconvert hmmDatabaseFiles/Pfam-A.hmm > hmmDatabaseFiles/Pfam-A_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB > hmmDatabaseFiles/TIGRFAM_converted.hmm # convert the database to the necessary format
cat hmmDatabaseFiles/Pfam-A_converted.hmm hmmDatabaseFiles/TIGRFAM_converted.hmm > hmmDatabaseFiles/converted_combined.hmm # combined all hidden Markov models into a single file
hmmpress hmmDatabaseFiles/converted_combined.hmm # prepare files for hmmscan searches

# Perform the HMMsearch screens
perl Scripts/performHMMsearch.pl # A short script to repeat for all HMM files, the build, hmmsearch, parsing, and hit extraction

# Perform the HMM scan screens
perl Scripts/performHMMscan.pl # A short script to repeat for all the HMM search output files, to perform hmmscan, parse, and hit extraction

# Determine strains with each protein
perl Scripts/determineProteinPresence.pl > Symbiotic_gene_distribution.txt # determine which of the six proteins are in each of the strains

# Extract proteins
perl Scripts/extractHMMscanHits_Nod.pl # extract all the Nod proteins
perl Scripts/extractHMMscanHits_Nif.pl # extract all the Nif proteins
sed -i 's/\t/\n/' SymbioticProteins/*_all.faa

# Make alignments
mafft --localpair --thread 1 SymbioticProteins/NodA_all.faa > SymbioticProteins/NodA_mafft.faa
mafft --localpair --thread 1 SymbioticProteins/NodB_all.faa > SymbioticProteins/NodB_mafft.faa
mafft --localpair --thread 1 SymbioticProteins/NodC_all.faa > SymbioticProteins/NodC_mafft.faa
mafft --localpair --thread 1 SymbioticProteins/NifH_all.faa > SymbioticProteins/NifH_mafft.faa
mafft --localpair --thread 1 SymbioticProteins/NifD_all.faa > SymbioticProteins/NifD_mafft.faa
mafft --localpair --thread 1 SymbioticProteins/NifK_all.faa > SymbioticProteins/NifK_mafft.faa
trimal -in SymbioticProteins/NodA_mafft.faa -out SymbioticProteins/NodA_trimal.faa -automated1
trimal -in SymbioticProteins/NodB_mafft.faa -out SymbioticProteins/NodB_trimal.faa -automated1
trimal -in SymbioticProteins/NodC_mafft.faa -out SymbioticProteins/NodC_trimal.faa -automated1
trimal -in SymbioticProteins/NifH_mafft.faa -out SymbioticProteins/NifH_trimal.faa -automated1
trimal -in SymbioticProteins/NifD_mafft.faa -out SymbioticProteins/NifD_trimal.faa -automated1
trimal -in SymbioticProteins/NifK_mafft.faa -out SymbioticProteins/NifK_trimal.faa -automated1

# Generate percent identity matrixes
Rscript Scripts/percentIdentity.R

# Make Nod protein phylogenies
cd Phylogenies
raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodA_trimal.faa -N 5 -n test_phylogeny_nodA -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodB_trimal.faa -N 5 -n test_phylogeny_nodB -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodC_trimal.faa -N 5 -n test_phylogeny_nodC -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
mpiexec --map-by node -np 10 raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodA_trimal.faa -N autoMRE -n NodA -f a -p 12345 -x 12345 -m PROTGAMMAJTTF
mpiexec --map-by node -np 10 raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodB_trimal.faa -N autoMRE -n NodB -f a -p 12345 -x 12345 -m PROTGAMMADUMMY2F
mpiexec --map-by node -np 10 raxmlHPC-HYBRID-AVX2 -T 1 -s ../SymbioticProteins/NodC_trimal.faa -N autoMRE -n NodC -f a -p 12345 -x 12345 -m PROTGAMMADUMMY2F
cd ..

# Determine replicons with proteins
grep '>' SymbioticProteins/*.faa | sed 's/>//' | sed 's/__/\t/g' | sed 's/:/\t/' | cut -f2,4 | sort -u | grep -v 'Mesorhizobium_alhagi_CCNWXJ12' > Symbiotic_gene_replicons.txt
cut -f2,2 Symbiotic_gene_replicons.txt > Symbiotic_gene_replicons2.txt
grep 'LOCUS' Genome_files/* | grep -f 'Symbiotic_gene_replicons2.txt' > Replicons_with_symbiotic_genes.txt

## NCBI analysis

# Prep genomes to extract nod genes
cd NCBI_analysis/Genomes/
cp ../../../6_Core_gene_phylogeny/Reannotate_genomes/Mesorhizobium_sp_AR*/*.ffn .
makeblastdb -in Mesorhizobium_sp_AR02.ffn -out AR02 -title AR02 -dbtype 'nucl'
makeblastdb -in Mesorhizobium_sp_AR07.ffn -out AR07 -title AR07 -dbtype 'nucl'
makeblastdb -in Mesorhizobium_sp_AR10.ffn -out AR10 -title AR10 -dbtype 'nucl'
cd ../../
perl Scripts/modifyFasta.pl NCBI_analysis/Genomes/Mesorhizobium_sp_AR02.ffn > NCBI_analysis/Genomes/Mesorhizobium_sp_AR02_modified.ffn
perl Scripts/modifyFasta.pl NCBI_analysis/Genomes/Mesorhizobium_sp_AR07.ffn > NCBI_analysis/Genomes/Mesorhizobium_sp_AR07_modified.ffn
perl Scripts/modifyFasta.pl NCBI_analysis/Genomes/Mesorhizobium_sp_AR10.ffn > NCBI_analysis/Genomes/Mesorhizobium_sp_AR10_modified.ffn

# Extract Nod proteins to identify nod genes
perl Scripts/extractHMMscanHits_Nod.pl # extract all the Nod proteins
grep 'Mesorhizobium_sp_AR' SymbioticProteins/NodA_all.faa > NCBI_analysis/NodA/AR_NodA.faa
grep 'Mesorhizobium_sp_AR' SymbioticProteins/NodB_all.faa > NCBI_analysis/NodB/AR_NodB.faa
grep 'Mesorhizobium_sp_AR' SymbioticProteins/NodC_all.faa > NCBI_analysis/NodC/AR_NodC.faa
sed -i 's/\t/\n/' SymbioticProteins/Nod*_all.faa
sed -i 's/\t/\n/' NCBI_analysis/Nod*/AR_Nod*.faa

# Cluster nodA genes from NCBI
tblastn -query NCBI_analysis/NodA/AR_NodA.faa -db NCBI_analysis/Genomes/AR02 -out NCBI_analysis/NodA/AR02_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodA/AR_NodA.faa -db NCBI_analysis/Genomes/AR07 -out NCBI_analysis/NodA/AR07_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodA/AR_NodA.faa -db NCBI_analysis/Genomes/AR10 -out NCBI_analysis/NodA/AR10_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
cut -f2,2 NCBI_analysis/NodA/AR*_blast.txt | sort -u > NCBI_analysis/NodA/AR_NodA_names.txt
grep -f 'NCBI_analysis/NodA/AR_NodA_names.txt' NCBI_analysis/Genomes/Mesorhizobium_sp_AR*_modified.ffn > NCBI_analysis/NodA/AR_NodA_genes.fna
sed -i 's/\t/\n/' NCBI_analysis/NodA/AR_NodA_genes.fna
cat Input_files/nodC_ncbi.fna NCBI_analysis/NodA/AR_NodA_genes.fna > NCBI_analysis/NodA/nodA_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR02_modified.ffn\://' NCBI_analysis/NodA/nodA_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR07_modified.ffn\://' NCBI_analysis/NodA/nodA_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR10_modified.ffn\://' NCBI_analysis/NodA/nodA_ncbi_ar.fna
cd-hit -i NCBI_analysis/NodA/nodA_ncbi_ar.fna -o NCBI_analysis/NodA/nodA_ncbi_ar -c 0.95 -G 1 -M 100000 -n 5 -aS 0.8 -T 24

# Cluster nodB genes from NCBI
tblastn -query NCBI_analysis/NodB/AR_NodB.faa -db NCBI_analysis/Genomes/AR02 -out NCBI_analysis/NodB/AR02_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodB/AR_NodB.faa -db NCBI_analysis/Genomes/AR07 -out NCBI_analysis/NodB/AR07_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodB/AR_NodB.faa -db NCBI_analysis/Genomes/AR10 -out NCBI_analysis/NodB/AR10_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
cut -f2,2 NCBI_analysis/NodB/AR*_blast.txt | sort -u > NCBI_analysis/NodB/AR_NodB_names.txt
grep -f 'NCBI_analysis/NodB/AR_NodB_names.txt' NCBI_analysis/Genomes/Mesorhizobium_sp_AR*_modified.ffn > NCBI_analysis/NodB/AR_NodB_genes.fna
sed -i 's/\t/\n/' NCBI_analysis/NodB/AR_NodB_genes.fna
cat Input_files/nodC_ncbi.fna NCBI_analysis/NodB/AR_NodB_genes.fna > NCBI_analysis/NodB/NodB_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR02_modified.ffn\://' NCBI_analysis/NodB/NodB_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR07_modified.ffn\://' NCBI_analysis/NodB/NodB_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR10_modified.ffn\://' NCBI_analysis/NodB/NodB_ncbi_ar.fna
cd-hit -i NCBI_analysis/NodB/NodB_ncbi_ar.fna -o NCBI_analysis/NodB/nodB_ncbi_ar -c 0.95 -G 1 -M 100000 -n 5 -aS 0.8 -T 24

# Cluster nodC genes from NCBI
tblastn -query NCBI_analysis/NodC/AR_NodC.faa -db NCBI_analysis/Genomes/AR02 -out NCBI_analysis/NodC/AR02_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodC/AR_NodC.faa -db NCBI_analysis/Genomes/AR07 -out NCBI_analysis/NodC/AR07_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
tblastn -query NCBI_analysis/NodC/AR_NodC.faa -db NCBI_analysis/Genomes/AR10 -out NCBI_analysis/NodC/AR10_blast.txt -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' -culling_limit 1 -max_target_seqs 1 -max_hsps 1
cut -f2,2 NCBI_analysis/NodC/AR*_blast.txt | sort -u > NCBI_analysis/NodC/AR_NodC_names.txt
grep -f 'NCBI_analysis/NodC/AR_NodC_names.txt' NCBI_analysis/Genomes/Mesorhizobium_sp_AR*_modified.ffn > NCBI_analysis/NodC/AR_NodC_genes.fna
sed -i 's/\t/\n/' NCBI_analysis/NodC/AR_NodC_genes.fna
cat Input_files/nodC_ncbi.fna NCBI_analysis/NodC/AR_NodC_genes.fna > NCBI_analysis/NodC/NodC_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR02_modified.ffn\://' NCBI_analysis/NodC/NodC_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR07_modified.ffn\://' NCBI_analysis/NodC/NodC_ncbi_ar.fna
sed -i 's/NCBI_analysis\/Genomes\/Mesorhizobium_sp_AR10_modified.ffn\://' NCBI_analysis/NodC/NodC_ncbi_ar.fna
cd-hit -i NCBI_analysis/NodC/NodC_ncbi_ar.fna -o NCBI_analysis/NodC/nodC_ncbi_ar -c 0.95 -G 1 -M 100000 -n 5 -aS 0.8 -T 24
