#!usr/bin/perl
use 5.010;

$input = @ARGV[0];

while(<>) {
	unless(/>/) {
		chomp;
		@line = split('', $_);
		foreach $i (@line) {
			$total++;
			if($i eq 'G') {
				$gc++;
			}
			elsif($i eq 'C') {
				$gc++;
			}

		}
	}
}
$perGC = 100 * $gc / $total;
say("$input\t$perGC");
