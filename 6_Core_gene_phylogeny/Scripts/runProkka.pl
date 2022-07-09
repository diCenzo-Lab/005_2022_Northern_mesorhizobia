#!usr/bin/perl
use 5.010;

while(<>) {
	@line = split("\t", $_);
	system("prokka --force --noanno --fast --outdir Reannotate_genomes/@line[0] --cpus 28 --prefix @line[0] Genome_files_input/@line[0].fna");
}
