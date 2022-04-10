#!/usr/bin/env bash

# Help message
if [ "$1" == "-h" ]; then
  echo "
  Usage: `basename $0` nanopore.fastq.gz illumina-1.fastq.gz illumina-2.fastq.gz output threads flye_threads

  Where:
    nanopore.fastq.gz: The gzipped basecalled nanopore data (uncorrected)
    illumina-1.fastq.gz: The first pair of Illumina reads from paired-end sequencing
    illumina-2.fastq.gz: The secpmd pair of Illumina reads from paired-end sequencing
    Output: The file name to use for the final assembly
    Threads: The number of threads to use
    Flye_threads: The number of threads to use with Flye
    "
  exit 0
fi
if [ "$1" == "-help" ]; then
  echo "
  Usage: `basename $0` nanopore.fastq.gz illumina-1.fastq.gz illumina-2.fastq.gz output threads flye_threads

  Where:
    nanopore.fastq.gz: The gzipped basecalled nanopore data (uncorrected)
    illumina-1.fastq.gz: The first pair of Illumina reads from paired-end sequencing
    illumina-2.fastq.gz: The secpmd pair of Illumina reads from paired-end sequencing
    Output: The file name to use for the output directory and the final assembly
    Threads: The number of threads to use
    Flye_threads: The number of threads to use with Flye
    "
  exit 0
fi
if [ "$1" == "--help" ]; then
  echo "
  Usage: `basename $0` nanopore.fastq.gz illumina-1.fastq.gz illumina-2.fastq.gz output threads flye_threads

  Where:
    nanopore.fastq.gz: The gzipped basecalled nanopore data (uncorrected)
    illumina-1.fastq.gz: The first pair of Illumina reads from paired-end sequencing
    illumina-2.fastq.gz: The secpmd pair of Illumina reads from paired-end sequencing
    Output: The file name to use for the final assembly
    Threads: The number of threads to use
    Flye_threads: The number of threads to use with Flye 
    "
  exit 0
fi

# Check for Output directory
if [ ! -d "${4}" ]; then
  mkdir "${4}"
fi

# Perform the initial assembly
mkdir "${4}/flye_assembly"
flye --nano-raw $1 --out-dir "${4}/flye_assembly" --threads $6

# Check for overlaps on ends
mkdir "${4}/overlap_removal_1"
nucmer --maxmatch --nosimplify -p "${4}/overlap_removal_1/assembly_overlaps" "${4}/flye_assembly/assembly.fasta" "${4}/flye_assembly/assembly.fasta"
show-coords -lrcTH "${4}/overlap_removal_1/assembly_overlaps.delta" > "${4}/overlap_removal_1/assembly_overlaps.coord"
parseCoord-nanopore.pl "${4}/overlap_removal_1/assembly_overlaps.coord" > "${4}/overlap_removal_1/assembly_overlaps.ToTrim.coord"
removeEnds-nanopore.pl "${4}/overlap_removal_1/assembly_overlaps.ToTrim.coord" "${4}/flye_assembly/assembly.fasta" > "${4}/overlap_removal_1/trimmed_assembly.fasta"

# Perform racon polishing using the nanopore data
mkdir "${4}/racon_correction"
minimap2 -x map-ont -d "${4}/racon_correction/index.mni" "${4}/overlap_removal_1/trimmed_assembly.fasta"
minimap2 -a "${4}/racon_correction/index.mni" ${1} > "${4}/racon_correction/mapped.sam"
racon -m 8 -x -6 -g -8 -w 500 -t $5 ${1} "${4}/racon_correction/mapped.sam" "${4}/overlap_removal_1/trimmed_assembly.fasta" > "${4}/racon_correction/assembly_racon.fasta"

# Perform medaka polishing using the nanopore data
mkdir "${4}/medaka_correction"
medaka_consensus -i ${1} -d "${4}/racon_correction/assembly_racon.fasta" -o "${4}/medaka_correction" -t $5 -m r941_min_hac_g507

# Perform pilon polishing using the illumina data
mkdir "${4}/pilon_polishing"
bwa index "${4}/medaka_correction/consensus.fasta"
bwa mem -t $5 "${4}/medaka_correction/consensus.fasta" ${2} ${3} -o "${4}/pilon_polishing/illumina_mapped.sam"
samtools sort -@ $5 "${4}/pilon_polishing/illumina_mapped.sam" > "${4}/pilon_polishing/illumina_mapped_sorted.sam"
samtools view -S -b -@ $5 "${4}/pilon_polishing/illumina_mapped_sorted.sam" > "${4}/pilon_polishing/illumina_mapped_sorted.bam"
samtools index -@ $5 "${4}/pilon_polishing/illumina_mapped_sorted.bam"
java -Xmx32G -jar /datadisk1/Bioinformatics_programs/pilon/pilon-1.24.jar --genome "${4}/medaka_correction/consensus.fasta" --bam "${4}/pilon_polishing/illumina_mapped_sorted.bam" --output "${4}/pilon_polishing/assembly_pilon" --changes --vcf > "${4}/pilon_polishing/assembly_pilon.txt"

# Perform racon polishing using the illumina data
mkdir "${4}/racon_polishing"
cat ${2} ${3} > "${4}/racon_polishing/combined_illumina.fastq.gz"
gunzip "${4}/racon_polishing/combined_illumina.fastq.gz"
sed -i 's/ //g' "${4}/racon_polishing/combined_illumina.fastq"
bwa index "${4}/pilon_polishing/assembly_pilon.fasta"
bwa mem -t $5 "${4}/pilon_polishing/assembly_pilon.fasta" "${4}/racon_polishing/combined_illumina.fastq" -o "${4}/racon_polishing/illumina_mapped.sam"
racon -t $5 "${4}/racon_polishing/combined_illumina.fastq" "${4}/racon_polishing/illumina_mapped.sam" "${4}/pilon_polishing/assembly_pilon.fasta" > "${4}/racon_polishing/assembly_racon.fasta"

# Check for overlaps on ends
mkdir "${4}/overlap_removal_2"
nucmer --maxmatch --nosimplify -p "${4}/overlap_removal_2/assembly_overlaps" "${4}/racon_polishing/assembly_racon.fasta" "${4}/racon_polishing/assembly_racon.fasta"
show-coords -lrcTH "${4}/overlap_removal_2/assembly_overlaps.delta" > "${4}/overlap_removal_2/assembly_overlaps.coord"
parseCoord-nanopore.pl "${4}/overlap_removal_2/assembly_overlaps.coord" > "${4}/overlap_removal_2/assembly_overlaps.ToTrim.coord"
removeEnds-nanopore.pl "${4}/overlap_removal_2/assembly_overlaps.ToTrim.coord" "${4}/racon_polishing/assembly_racon.fasta" > "${4}/overlap_removal_2/trimmed_assembly.fasta"

# Reorient the replicons
mkdir "${4}/circlator_output"
circlator fixstart "${4}/overlap_removal_2/trimmed_assembly.fasta" final_assembly
mv final_assembly* "${4}/circlator_output"

# Get final assembly and compress everything
cp "${4}/circlator_output/final_assembly.fasta" "${4}/${4}.fasta"
gzip -r "${4}/flye_assembly" &
gzip -r "${4}/overlap_removal_1" &
gzip -r "${4}/racon_correction" &
gzip -r "${4}/medaka_correction" &
gzip -r "${4}/pilon_polishing" &
gzip -r "${4}/racon_polishing" &
gzip -r "${4}/overlap_removal_2" &
gzip -r "${4}/circlator_output" &
wait

