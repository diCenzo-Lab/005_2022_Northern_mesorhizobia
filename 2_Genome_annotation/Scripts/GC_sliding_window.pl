#!usr/bin/perl
use 5.010;
use List::Util qw/sum/;

$input = @ARGV[0];
@output = split('/', $input);
$output = @output[1];
$output =~ s/\.fna//;

open($in, '<', $input);
while(<$in>) {
  chomp;
  if(/>/) {
    if($. != 1) {
      $output2 = 'GC_sliding_window/' . $output . '_' . $replicon . '.txt';
      open($out, '>', $output2);
      for($n = 5000; $n <= scalar (@GC) - 5000; $n = $n + 1000) {
        $GC_content = 100 * sum(@GC[$n-5000..$n+4999]) / 10000;
        say $out ("$n\t$GC_content");
      }
      close($out);
    }
    $_ =~ s/>//;
    $replicon = $_;
    @GC = ();
  }
  else {
    @line = split('', $_);
    foreach $i (@line) {
      if($i eq 'G' || $i eq 'C') {
        push(@GC, '1');
      }
      else {
        push(@GC, '0');
      }
    }
  }
}
$output2 = 'GC_sliding_window/' . $output . '_' . $replicon . '.txt';
open($out, '>', $output2);
for($n = 5000; $n <= scalar (@GC) - 5000; $n = $n + 1000) {
  $GC_content = 100 * sum(@GC[$n-5000..$n+4999]) / 10000;
  say $out ("$n\t$GC_content");
}
close($out);
close($in);
