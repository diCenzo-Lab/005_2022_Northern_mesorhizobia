#!usr/bin/perl

$size = 0;
while(<>) {
chomp;
  if(/>/) {
    chomp;
    $_ =~ s/>//;
    if($size != 0) {
      print("$size\n");
      $size = 0;
    }
    print("$_\t");
  }
  else {
    $size = $size + length $_;
  }
}
print("$size\n");
