#!usr/bin/perl
use 5.010;

while(<>) {
	@line = split("\t", $_);
	system("cp Reannotate_genomes/@line[0]/@line[0].gff Genome_files/");
}
