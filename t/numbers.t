use Test::More qw[no_plan];
use strict;
use FindBin;

use lib qw[lib ../lib];

BEGIN {
	use_ok 'Parse::PhoneNumber';
}

my $p = Parse::PhoneNumber->new;

isa_ok $p, 'Parse::PhoneNumber';

my ($good, $bad) = (0, 0);

open NUMBERS, "$FindBin::Bin/numbers.txt"
	or die "Can't open numbers: $!";
while ( <NUMBERS> ) {
	chomp;
	my $number = $p->parse( number => $_ );
	if ( $number ) {
		$good++;
		isa_ok $number,          'Parse::PhoneNumber::Number';
		like   $number->cc,      qr/^\d{1,3}$/, "Proper CC code: ".$number->cc;
		is     $number->orig,    $_, "Original number: ".$number->orig;
		like   $number->num,     qr/^\d+$/, "Original matches: $_";
		like   $number->opensrs, qr/\+\d+\.\d+(?:x\d+)?/, "Opensrs syntax correct: ".$number->opensrs;
		like   $number->human,   qr/\+\d+\s+\d+(?:x\d+)?/, "Human readable format: ".$number->human;
		if ( $number->ext ) {
			like $number->ext, qr/\d+/, "Extension: ".$number->ext;
		} else {
			is $number->ext, undef, "No extension is undef";
		}
	} else {
		$bad++;
		ok $p->errstr, "Error string set.";
		is $number, undef, $p->errstr;
	}
}
close NUMBERS;

is $good, 214, "$good good numbers";
is $bad,  31,  "$bad bad numbers";
