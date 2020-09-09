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
     if ((index($_, "After layer change") > 0) && ($last == 0)) {
        $last = 1;
     }
     if ($last == 1) {
        print;
     } else {
        if ($first == 0) {
           print;
        } else {
           if (index(" ".$_, "G1 Z1.0") == 1) { $_ =~ s/G1 Z1/G1 Z5/ig; }
           print;
        }
     }
}
