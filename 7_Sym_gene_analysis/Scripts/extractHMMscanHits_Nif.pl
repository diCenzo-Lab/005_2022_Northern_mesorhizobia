#!usr/bin/perl
use 5.010;

# List of files
$genePresence = 'Symbiotic_gene_distribution.txt';
$nifH_file = 'HMMscanTop/NifH.csv';
$nifD_file = 'HMMscanTop/NifD.csv';
$nifK_file = 'HMMscanTop/NifK.csv';
$nifH_out_file = 'HMMscanTopLists/NifH.txt';
$nifD_out_file = 'HMMscanTopLists/NifD.txt';
$nifK_out_file = 'HMMscanTopLists/NifK.txt';

# Find strains with all Nif proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[8] == 1) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get NifH proteins
open($nifH,'<',$nifH_file);
open($nifH_out,'>',$nifH_out_file);
while(<$nifH>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR01287') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifH_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'Fer4_NifH') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifH_out (@line[0]);
				}
			}
		}
	}
}
close($nifH);
close($nifH_out);
system("grep -f 'HMMscanTopLists/NifH.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NifH_all.faa");

# Get NifD proteins
open($nifD,'<',$nifD_file);
open($nifD_out,'>',$nifD_out_file);
while(<$nifD>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR01282') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifD_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'TIGR01860') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifD_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'TIGR01861') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifD_out (@line[0]);
				}
			}
		}
	}
}
close($nifD);
close($nifD_out);
system("grep -f 'HMMscanTopLists/NifD.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NifD_all.faa");

# Get NifK proteins
open($nifK,'<',$nifK_file);
open($nifK_out,'>',$nifK_out_file);
while(<$nifK>) {
	@line = split(',',$_);
	if(@line[1] <= 1e-50) {
		if(@line[9] eq 'TIGR02932') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifK_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'TIGR02931') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifK_out (@line[0]);
				}
			}
		}
		elsif(@line[9] eq 'TIGR01286') {
			@line2 = split('__', @line[0]);
			foreach $i (@species) {
				if(@line2[0] eq $i) {
					say $nifK_out (@line[0]);
				}
			}
		}
	}
}
close($nifK_out);
close($nifK);
system("grep -f 'HMMscanTopLists/NifK.txt' combined_proteomes_HMM_modified.faa > SymbioticProteins/NifK_all.faa");

