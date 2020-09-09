#! /usr/bin/perl -i

use strict;
use warnings;

my $first = 0;
my $last = 0;
my $part1 = "";
my $part2 = "";
my $layer = 0;
my $height = 0;
#
# Debug states
#
# 0 No debugging
# 1 Check Layer corrections
# 10 Straight through

my $Debug = 0;

while (<>) {
    if ($Debug < 9) {
        # ;LAYER:0 @ 0.35
        if ((index($_, "LAYER:") > 0) && (index($_, "LAYER:") < 7)) {
            my $info = $_;
            $info =~ tr/ //;
            chomp($info);
            ($part1,$part2) = split(":", $info);
            ($layer,$height) = split(" @ ", $part2);
            if ($layer == 0) {
                $first = $height;
                $_ = ";LAYER:0\n";
            } else {
                if ($height eq $first) {
                    $_ = "\n";
                } else {
                    $first = $height;
                    $last = $last + 1;
                    $_ = ";LAYER:".$last."\n";
                }
            }
        }
        print;
    } else {
        print;
    }
}

