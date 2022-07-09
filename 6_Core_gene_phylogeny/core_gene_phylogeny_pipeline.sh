# Make directories
mkdir Input_files/
mkdir Genome_files/
mkdir Genome_files_input/
mkdir Phylogeny/

# Reannotate genomes
cp ../3_ANI_matrix/Input_files/genomeList.txt Input_files/
cp ../3_ANI_matrix/Genome_files/*.fna Genome_files_input/
perl Scripts/runProkka.pl Input_files/genomeList.txt # Run prokka to annotate the genomes
perl Scripts/moveGenomes.pl Input_files/genomeList.txt # Collect important reannotated genome files

# Construct pangenome
roary -p 28 -f Roary_output -e -n -i 70 -g 150000 Genome_files/*.gff # Run roary
trimal -in Roary_output/core_gene_alignment.aln -out core_gene_alignment_trimmed.aln -fasta -automated1 # Trim the alignment made by Roary
mv core_gene_alignment_trimmed.aln Phylogeny/
cd Phylogeny/
raxmlHPC-HYBRID-AVX2 -T 28 -s core_gene_alignment_trimmed.aln -N autoMRE -n core_gene_phylogeny -f a -p 12345 -x 12345 -m GTRCAT
cd ../
