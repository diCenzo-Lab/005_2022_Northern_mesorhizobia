## The scipts in the Scripts directory need to be added to your path prior to running this pipeline

# Basecall the Nanopore data
mkdir Basecalled_nanopore_data
guppy_basecaller -i ./Raw_nanopore_data/AR02/ -s ./Basecalled_nanopore_data/AR02/ --flowcell FLO-MIN106 --kit SQK-RAD004 -x "cuda:0"
guppy_basecaller -i ./Raw_nanopore_data/AR07/ -s ./Basecalled_nanopore_data/AR07/ --flowcell FLO-MIN106 --kit SQK-RAD004 -x "cuda:0"
guppy_basecaller -i ./Raw_nanopore_data/AR10/ -s ./Basecalled_nanopore_data/AR10/ --flowcell FLO-MIN106 --kit SQK-RAD004 -x "cuda:0"
cat Basecalled_nanopore_data/AR02/pass/*.fastq > Basecalled_nanopore_data/AR02.fastq
cat Basecalled_nanopore_data/AR07/pass/*.fastq > Basecalled_nanopore_data/AR07.fastq
cat Basecalled_nanopore_data/AR10/pass/*.fastq > Basecalled_nanopore_data/AR10.fastq
gzip Basecalled_nanopore_data/AR02.fastq &
gzip Basecalled_nanopore_data/AR07.fastq &
gzip Basecalled_nanopore_data/AR10.fastq &
gzip -r Basecalled_nanopore_data/AR02/ &
gzip -r Basecalled_nanopore_data/AR07/ &
gzip -r Basecalled_nanopore_data/AR10/ &
wait

# Assemble and polish the genomes
mkdir Assembled_genomes
mkdir Assembled_genomes/Intermediate_files/
nanopore_assembly.sh Basecalled_nanopore_data/AR02.fastq.gz Illumina_data/AR02_S22_R1_001.fastq.gz Illumina_data/AR02_S22_R2_001.fastq.gz AR02 16 16
nanopore_assembly.sh Basecalled_nanopore_data/AR07.fastq.gz Illumina_data/AR07_S23_R1_001.fastq.gz Illumina_data/AR07_S23_R2_001.fastq.gz AR07 16 16
nanopore_assembly.sh Basecalled_nanopore_data/AR10.fastq.gz Illumina_data/AR10_S24_R1_001.fastq.gz Illumina_data/AR10_S24_R2_001.fastq.gz AR10 16 16
mv AR02 Assembled_genomes/Intermediate_files
mv AR07 Assembled_genomes/Intermediate_files
mv AR10 Assembled_genomes/Intermediate_files
cp Assembled_genomes/Intermediate_files/*/*.fasta Assembled_genomes

# Rename contigs
sed -i 's/contig_2_pilon LN:i:7468087 RC:i:5917586 XC:f:1.000000/contig_1 [location=chromosome] [topology=circular]/' Assembled_genomes/AR02.fasta
sed -i 's/contig_1_pilon LN:i:988422 RC:i:770202 XC:f:1.000000/contig_2 [location=plasmid] [plasmid-name=pAR01] [topology=circular]/' Assembled_genomes/AR02.fasta
sed -i 's/contig_4_pilon LN:i:357630 RC:i:121286 XC:f:1.000000/contig_3 [location=plasmid] [plasmid-name=pAR02] [topology=circular]/' Assembled_genomes/AR02.fasta
sed -i 's/contig_3_pilon LN:i:95476 RC:i:53303 XC:f:1.000000/contig_4 [location=plasmid] [plasmid-name=pAR03] [topology=circular]/' Assembled_genomes/AR02.fasta
sed -i 's/contig_1_pilon LN:i:6659189 RC:i:6002335 XC:f:1.000000/contig_1 [location=chromosome] [topology=circular]/' Assembled_genomes/AR07.fasta
sed -i 's/contig_4_pilon LN:i:1021442 RC:i:1099922 XC:f:1.000000/contig_2 [location=plasmid] [plasmid-name=pAR04] [topology=circular]/' Assembled_genomes/AR07.fasta
sed -i 's/contig_2_pilon LN:i:359503 RC:i:268033 XC:f:1.000000/contig_3 [location=plasmid] [plasmid-name=pAR05] [topology=circular]/' Assembled_genomes/AR07.fasta
sed -i 's/contig_3_pilon LN:i:348101 RC:i:262886 XC:f:1.000000/contig_4 [location=plasmid] [plasmid-name=pAR06] [topology=circular]/' Assembled_genomes/AR07.fasta
sed -i 's/contig_5_pilon LN:i:345015 RC:i:238096 XC:f:1.000000/contig_5 [location=plasmid] [plasmid-name=pAR07] [topology=circular]/' Assembled_genomes/AR07.fasta
sed -i 's/contig_2_pilon LN:i:6127963 RC:i:4184953 XC:f:1.000000/contig_1 [location=chromosome] [topology=circular]/' Assembled_genomes/AR10.fasta
sed -i 's/contig_1_pilon LN:i:750264 RC:i:382261 XC:f:1.000000/contig_2 [location=plasmid] [plasmid-name=pAR08] [topology=circular]/' Assembled_genomes/AR10.fasta

# Test assembly using Canu
mkdir Canu_assembled_genomes
canu -p AR02 -d AR02-canu genomeSize=8.9m -nanopore-raw Basecalled_nanopore_data/AR02.fastq.gz -minThreads=16 -maxThreads=16
canu -p AR07 -d AR07-canu genomeSize=8.7m -nanopore-raw Basecalled_nanopore_data/AR07.fastq.gz -minThreads=16 -maxThreads=16
canu -p AR10 -d AR10-canu genomeSize=6.9m -nanopore-raw Basecalled_nanopore_data/AR10.fastq.gz -minThreads=16 -maxThreads=16
gzip -r AR02-canu/AR02.seqStore &
gzip -r AR02-canu/correction &
gzip -r AR02-canu/trimming &
gzip -r AR02-canu/unitigging &
gzip -r AR07-canu/AR07.seqStore &
gzip -r AR07-canu/correction &
gzip -r AR07-canu/trimming &
gzip -r AR07-canu/unitigging &
gzip -r AR10-canu/AR10.seqStore &
gzip -r AR10-canu/correction &
gzip -r AR10-canu/trimming &
gzip -r AR10-canu/unitigging &
wait
mv AR02-canu Canu_assembled_genomes
mv AR07-canu Canu_assembled_genomes
mv AR10-canu Canu_assembled_genomes
