#!usr/bin/perl
use 5.010;

# Input files
$fastANI = 'Output/fastani_output_twoWay.txt';
$strainList = 'intermediaryFiles/genomePaths.txt';

# Prepare array of strains
open($list, '<', $strainList);
while(<$list>) {
        chomp;
        push(@strains, $_);
}
close($list);

# Print header row
print("Strain");
foreach $a (@strains) {
        print("\t$a");
}
print("\n");

# Prepare matrix
$data = 75;
$data2 = 75;
foreach $i (@strains) {
  print("$i");
  foreach $j (@strains) {
    open($ANI, '<', $fastANI);
    while(<$ANI>) {
      @line = split(" ", $_);
      if(@line[0] eq $i) {
        if(@line[1] eq $j) {
          $data = @line[2];
        }
      }
      if(@line[0] eq $j) {
        if(@line[1] eq $i) {
          $data2 = @line[2];
        }
      }
    }
    $avg = ($data + $data2) / 2;
    close($ANI);
    print("\t$avg");
    $data = 75;
    $data2 = 75;
  }
  print("\n");
}
