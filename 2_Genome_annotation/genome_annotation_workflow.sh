# Make new directories
mkdir Input_Genomes
mkdir Prophages
mkdir GC_sliding_window
mkdir CRISPR
mkdir Stats

# Get genomes of interest to proceed with
cp ../1_Genome_assembly/Assembled_genomes/*.fasta Input_Genomes/

# Annotate genomes using NCBI PGAP (2021-07-01.build5508)
cp Input_Genomes/* .
cp yaml_input_files/* .
pgap.py -n -o AR02 AR02.yaml -c 16 -m 100g
pgap.py -n -o AR07 AR07.yaml -c 16 -m 100g
pgap.py -n -o AR10 AR10.yaml -c 16 -m 100g

# Clean directory
rm AR*.fasta
rm *.yaml
rm VERSION
rm -r input-2021-07-01.build5508/
rm -r test_genomes-2021-07-01.build5508/
rm test_genomes
mkdir Annotated_genomes
mv AR02 Annotated_genomes
mv AR07 Annotated_genomes
mv AR10 Annotated_genomes

# Update file names and gene names
mv Annotated_genomes/AR02/annot.faa Annotated_genomes/AR02/Mesorhizobium_sp_AR02.faa
mv Annotated_genomes/AR02/annot.fna Annotated_genomes/AR02/Mesorhizobium_sp_AR02.fna
mv Annotated_genomes/AR02/annot.gbk Annotated_genomes/AR02/Mesorhizobium_sp_AR02.gbk
mv Annotated_genomes/AR02/annot.gff Annotated_genomes/AR02/Mesorhizobium_sp_AR02.gff
mv Annotated_genomes/AR02/annot.sqn Annotated_genomes/AR02/Mesorhizobium_sp_AR02.sqn
sed -i 's/pgaptmp/DBIPINDM/' Annotated_genomes/AR02/*
mv Annotated_genomes/AR07/annot.faa Annotated_genomes/AR07/Mesorhizobium_sp_AR07.faa
mv Annotated_genomes/AR07/annot.fna Annotated_genomes/AR07/Mesorhizobium_sp_AR07.fna
mv Annotated_genomes/AR07/annot.gbk Annotated_genomes/AR07/Mesorhizobium_sp_AR07.gbk
mv Annotated_genomes/AR07/annot.gff Annotated_genomes/AR07/Mesorhizobium_sp_AR07.gff
mv Annotated_genomes/AR07/annot.sqn Annotated_genomes/AR07/Mesorhizobium_sp_AR07.sqn
sed -i 's/pgaptmp/BPNPMPFG/' Annotated_genomes/AR07/*
mv Annotated_genomes/AR10/annot.faa Annotated_genomes/AR10/Mesorhizobium_sp_AR10.faa
mv Annotated_genomes/AR10/annot.fna Annotated_genomes/AR10/Mesorhizobium_sp_AR10.fna
mv Annotated_genomes/AR10/annot.gbk Annotated_genomes/AR10/Mesorhizobium_sp_AR10.gbk
mv Annotated_genomes/AR10/annot.gff Annotated_genomes/AR10/Mesorhizobium_sp_AR10.gff
mv Annotated_genomes/AR10/annot.sqn Annotated_genomes/AR10/Mesorhizobium_sp_AR10.sqn
sed -i 's/pgaptmp/LHFGNBLO/' Annotated_genomes/AR10/*

# Predict CRISPR with PROKKA
prokka --cpus 16 --outdir CRISPR/AR02 --prefix Mesorhizobium_sp_AR02 --force --genus Mesorhizobium --species sp. --strain AR02 Annotated_genomes/AR02/Mesorhizobium_sp_AR02.fna --fast --noanno
prokka --cpus 16 --outdir CRISPR/AR07 --prefix Mesorhizobium_sp_AR07 --force --genus Mesorhizobium --species sp. --strain AR07 Annotated_genomes/AR07/Mesorhizobium_sp_AR07.fna --fast --noanno
prokka --cpus 16 --outdir CRISPR/AR10 --prefix Mesorhizobium_sp_AR10 --force --genus Mesorhizobium --species sp. --strain AR10 Annotated_genomes/AR10/Mesorhizobium_sp_AR10.fna --fast --noanno

# Predict prophage regions
PhiSpy.py Annotated_genomes/AR02/Mesorhizobium_sp_AR02.gbk -o Prophages/AR02
PhiSpy.py Annotated_genomes/AR07/Mesorhizobium_sp_AR07.gbk -o Prophages/AR07
PhiSpy.py Annotated_genomes/AR10/Mesorhizobium_sp_AR10.gbk -o Prophages/AR10

# Calculate GC content in a sliding window
perl Scripts/GC_sliding_window.pl Annotated_genomes/AR02/Mesorhizobium_sp_AR02.fna
perl Scripts/GC_sliding_window.pl Annotated_genomes/AR07/Mesorhizobium_sp_AR07.fna
perl Scripts/GC_sliding_window.pl Annotated_genomes/AR10/Mesorhizobium_sp_AR10.fna

# Get some assembly stats
perl Scripts/calculateGCcontent.pl Annotated_genomes/AR02/Mesorhizobium_sp_AR02.fna > Stats/GC_content.txt
perl Scripts/calculateGCcontent.pl Annotated_genomes/AR07/Mesorhizobium_sp_AR07.fna >> Stats/GC_content.txt
perl Scripts/calculateGCcontent.pl Annotated_genomes/AR10/Mesorhizobium_sp_AR10.fna >> Stats/GC_content.txt
perl Scripts/calculateRepliconSize.pl Annotated_genomes/AR02/Mesorhizobium_sp_AR02.fna > Stats/Replicon_sizes.txt
perl Scripts/calculateRepliconSize.pl Annotated_genomes/AR07/Mesorhizobium_sp_AR07.fna >> Stats/Replicon_sizes.txt
perl Scripts/calculateRepliconSize.pl Annotated_genomes/AR10/Mesorhizobium_sp_AR10.fna >> Stats/Replicon_sizes.txt
