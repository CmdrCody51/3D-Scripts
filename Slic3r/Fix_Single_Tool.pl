#! /usr/bin/perl -i

use strict;
use warnings;

my $first = 0;
my $last = 0;

while (<>) {
     # modify $_ here before printing
     if ((index($_, "Before layer change") > 0) && ($first == 0)) {
        $first = 1;
     }
     if ($last == 1) {
        print;
     } else {
        if ($first == 0) {
           print;
        } else {
           print;
           print "OCTO100\nG4 P500\nG1 F200 E15\nM400\nG92 E0\n";
           $last = 1;
        }
     }
}
