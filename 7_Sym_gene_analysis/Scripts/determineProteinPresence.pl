#!usr/bin/perl
use 5.010;

# List of files
$strainFile = 'Input_files/genomeList.txt';
$nodA_file = 'HMMscanTop/NodA.csv';
$nodB_file = 'HMMscanTop/NodB.csv';
$nodC_file = 'HMMscanTop/NodC.csv';
$nifH_file = 'HMMscanTop/NifH.csv';
$nifD_file = 'HMMscanTop/NifD.csv';
$nifK_file = 'HMMscanTop/NifK.csv';

# Prepare lists of strain/species names
open($strainList,'<',$strainFile);
while(<$strainList>) {
	chomp;
	@strainLine = split("\t",$_);
	@strainLine2 = split('_',@strainLine[0]);
	$partialStrain = "@strainLine2[0]_@strainLine2[1]";
	push(@strainsFull,@strainLine[0]);
	push(@strainsPartial,$partialStrain);
	push(@species,$partialStrain);
}

# Determine presence of the six genes
say("Strain\tNodA\tNodB\tNodC\tNifH\tNifD\tNifK\tNodABC\tNifHDK\tAll");
$count = -1;
foreach $i (@strainsFull) {
	$count++;
	@hitArray = qw( 0 0 0 0 0 0 0 0 0 );
	open($nodA,'<',$nodA_file);
	while(<$nodA>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR04245') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'NodA') {
				@hitArray[0] = '1';
			}
		}
	}
	close($nodA);
	open($nodB,'<',$nodB_file);
	while(<$nodB>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR04243') {
				@hitArray[1] = '1';
			}
		}
	}
	close($nodB);
	open($nodC,'<',$nodC_file);
	while(<$nodC>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR04242') {
				@hitArray[2] = '1';
			}
		}
	}
	close($nodC);
	open($nifH,'<',$nifH_file);
	while(<$nifH>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR01287') {
				@hitArray[3] = '1';
			}
			elsif(@line[9] eq 'Fer4_NifH') {
				@hitArray[3] = '1';
			}
		}
	}
	close($nifH);
	open($nifD,'<',$nifD_file);
	while(<$nifD>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR01282') {
				@hitArray[4] = '1';
			}
			elsif(@line[9] eq 'TIGR01860') {
				@hitArray[4] = '1';
			}
			elsif(@line[9] eq 'TIGR01861') {
				@hitArray[4] = '1';
			}
		}
	}
	close($nifD);
	open($nifK,'<',$nifK_file);
	while(<$nifK>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'TIGR02932') {
				@hitArray[5] = '1';
			}
			elsif(@line[9] eq 'TIGR02931') {
				@hitArray[5] = '1';
			}
			elsif(@line[9] eq 'TIGR01286') {
				@hitArray[5] = '1';
			}
		}
	}
	close($nifK);
	if(@hitArray[0] + @hitArray[1] + @hitArray[2] == 3) {
		@hitArray[6] = '1';
	}
	if(@hitArray[3] + @hitArray[4] + @hitArray[5] == 3) {
		@hitArray[7] = '1';
	}
	if(@hitArray[6] + @hitArray[7] == 2) {
		@hitArray[8] = '1';
	}
	say("@strainsFull[$count]\t@hitArray[0]\t@hitArray[1]\t@hitArray[2]\t@hitArray[3]\t@hitArray[4]\t@hitArray[5]\t@hitArray[6]\t@hitArray[7]\t@hitArray[8]");
}
