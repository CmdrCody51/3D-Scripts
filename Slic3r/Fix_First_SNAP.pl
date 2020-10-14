#! /usr/bin/perl -i

use strict;
use warnings;

my $first = 0;
my $last = 0;

while (<>) {
     # modify $_ here before printing
     if ((index(" ".$_, "SNAP") > 0) && ($first == 0)) {
        $first = 1;
     }
     if ((index(" ".$_, "SNAP") > 0) && ($last == 0)) {
     
# Do the magic     

        my $one = <>;
        my $two = <>;
        my $three = <>;
        print $two;
        print $three;
        print;
        print $two;
        print $one;
        print $three;
        $_ = "\n";
        $last = 1;

     }
     print;
}
