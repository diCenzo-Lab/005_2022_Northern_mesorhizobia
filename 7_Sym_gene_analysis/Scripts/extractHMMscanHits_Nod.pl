#!usr/bin/perl
use 5.010;

# List of files
$genePresence = 'Symbiotic_gene_distribution.txt';
$nodA_file = 'HMMscanTop/NodA.csv';
$nodB_file = 'HMMscanTop/NodB.csv';
$nodC_file = 'HMMscanTop/NodC.csv';
$nodA_out_file = 'HMMscanTopLists/NodA.txt';
$nodB_out_file = 'HMMscanTopLists/NodB.txt';
$nodC_out_file = 'HMMscanTopLists/NodC.txt';

# Find strains with all Nod proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[7] == 1) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get NodA proteins
open($nodA,'<',$nodA_file);
open($nodA_out,'>',$nodA_out_file);
while(<$nodA>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR04245') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nodA_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'NodA') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nodA_out (@line[0]);
				}
			}
		}
	}
}
close($nodA);
close($nodA_out);
system("grep -f 'HMMscanTopLists/NodA.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NodA_all.faa");

# Get NodB proteins
open($nodB,'<',$nodB_file);
open($nodB_out,'>',$nodB_out_file);
while(<$nodB>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR04243') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nodB_out (@line[0]);
				}
			}
		}
	}
}
close($nodB);
close($nodB_out);
system("grep -f 'HMMscanTopLists/NodB.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NodB_all.faa");

# Get NodC proteins
open($nodC,'<',$nodC_file);
open($nodC_out,'>',$nodC_out_file);
while(<$nodC>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR04242') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nodC_out (@line[0]);
				}
			}
		}
	}
}
close($nodC);
close($nodC_out);
system("grep -f 'HMMscanTopLists/NodC.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NodC_all.faa");

