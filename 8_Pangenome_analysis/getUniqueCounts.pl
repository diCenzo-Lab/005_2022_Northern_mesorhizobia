#!usr/bin/perl
use 5.010;

# Get species names and locus tags
$input = '../Input_files/Species_gene_names.csv';
open($in, '<', $input);
while(<$in>) {
  chomp;
  if($. == 1) {
    @strains = split(',', $_);
  }
  if($. == 2) {
    @loci = split(',', $_);
  }
}
close($in);

# Get unique counts
foreach $strain (@strains) {
  $strain2 = $strain . '.gff';
  @locus = split('_', @loci[0]);
  $locus = @locus[0];
  print("$strain\t");
  system("sh ../getUniqueCounts.sh $locus");
  shift(@loci);
}

