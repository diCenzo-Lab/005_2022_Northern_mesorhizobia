#!/usr/bin/env perl
use 5.010;

# Input files
$coord_file = @ARGV[0];
$assembly_file = @ARGV[1];

# Get coordinates
open($in, '<', $coord_file);
while(<$in>) {
  @line = split("\t", $_);
  push(@replicon, @line[11]);
  push(@coord, @line[2]);
}
close($in);

# Remove ends
open($in, '<', $assembly_file);
while(<$in>) {
  chomp;
  if(/>/) {
    say($_);
    $count = 0;
    $j = 0;
    $test = 0;
    foreach $i (@replicon) {
      $j++;
      if(/$i/) {
        $pos = $j-1;
        $test = 1;
      }
    }
  }
  elsif($test == 1) {
    @line = split('', $_);
    foreach $i (@line) {
      $count++;
      if($count < @coord[$pos]) {
        print($i);
      }
      else {
        $test = -1;
      }
    }
    print("\n");
  }
  elsif($test == 0) {
    say($_);
  }
}


