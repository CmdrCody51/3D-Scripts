#! /usr/bin/perl -w

use strict;
use warnings;
use POSIX;
use File::Basename;
use YAML::Tiny;
use constant PI => 4 * atan2(1, 1);

=pod

use IO::Tee;

my $log_filename = "log.txt";
my $log_filehandle;
open( $log_filehandle, '>>', $log_filename )
  or die("Can't open $log_filename for append: $!");
my $tee = IO::Tee->new( $log_filehandle, \*STDOUT );
*STDERR = *$tee{IO};
select $tee;

=cut

my $dirname = dirname(__FILE__);
my $file = $ARGV[0];
my $Debug = 0;
my @gcode;

open my $info, "<:encoding(utf8)",$file or die "Could not open $file: $!";
chomp(@gcode = <$info>);
close $info;

open $info, ">:encoding(utf8)",$file or die "Could not open $file: $!";

# Open the config
my $yaml = YAML::Tiny->read( $dirname.'/'.'parse_config.yml' );
 
# Get a reference to the first document
my $list = $yaml->[0]->{alphabet}->{list};
my $strip_space = $yaml->[0]->{alphabet}->{strip_spaces};
my $drop_blanks = $yaml->[0]->{alphabet}->{drop_blank_lines};
my $comment_char = $yaml->[0]->{alphabet}->{comment_char};
my $no_comments = $yaml->[0]->{alphabet}->{keep_comments};
my $repeat_comments = $yaml->[0]->{alphabet}->{repeat_comments};
$Debug = $yaml->[0]->{alphabet}->{debug};

my $specials = 0;
if ( exists $yaml->[0]->{specials}->{count} ) {
  $specials = $yaml->[0]->{specials}->{count};
}

my $drops = 0;
if ( exists $yaml->[0]->{drops}->{count} ) {
  $drops = $yaml->[0]->{drops}->{count};
}

# known specials chars -> # ! /

my $last_comment = "";
my @vals;
my $key = "";

my $q = 0;
my $ptr = 'sid';
my @lookout;
if ($specials > 0) {
# read in spec name and equals
  while ( $q < $specials ) {
    my $ray = $ptr.$q;
    push(@lookout,$yaml->[0]->{$ray}->{name});
    push(@lookout,$yaml->[0]->{$ray}->{equal});
    $q++;
  }
}

if ($Debug) {
  print "Specials in GCode\n";
  for (my $ff=0;$ff<@lookout;$ff+=2) {
    print $lookout[$ff]." using ".$lookout[$ff+1]."\n";
  }
  print "Hit ENTER to continue...\n";
  <STDIN>;
}

$q = 0;
$ptr = 'did';
my @droplist;
if ($drops > 0) {
  while ( $q < $drops ) {
    my $ray = $ptr.$q;
    push(@droplist,$yaml->[0]->{$ray}->{string});
    push(@droplist,$yaml->[0]->{$ray}->{equal});
    $q++;
  }
}

if ($Debug) {
  print "Drops in GCode\n";
  for (my $ff=0;$ff<@lookout;$ff+=2) {
    print $droplist[$ff]." using ".$droplist[$ff+1]."\n";
  }
  print "Hit ENTER to continue...\n";
  <STDIN>;
}

for (my $i=0;$i<@gcode;$i++) {
   if ($Debug) { print "Input: ".$gcode[$i]."\n"; }
   @vals = Do_Parse($gcode[$i]);
   if (@vals == 0) { print "Error at ".($i+1)."\n"; }
   my $w = 1;
   my $v = 0;
   my $no_print = 0;
   my @display_list = split(//,$vals[0]);
   if (@display_list) {
     while ($w < @vals) {
        if (($display_list[$v] eq '@') || ($display_list[$v] eq '*')) {
          if ($display_list[$v] eq '@') {
# it's a special!
# read numbers
            my $optr = $v+1;
            my $nptr = "";
            while ( $optr < @display_list ) {
              if ($display_list[$optr] =~ /[0123456789]/ ) {
                $nptr .= $display_list[$optr];
                $optr++;
              } else {
                last;
              }
            }
            if ($Debug) {
              print "Doing @ with ptr to : ".$nptr."\n";
              print $lookout[$nptr]." <> *".$lookout[$nptr+1]."*\n";
              print $vals[$w]."\n";
              <STDIN>;
            }
# use that as index into $lookout
# depends doesn't it...
            $key = "@";
            if ($lookout[$nptr+1] ne "") {
              $key = $lookout[$nptr+1];
              print $info $lookout[$nptr];
              $no_print++;
            }
          }
          if ($display_list[$v] eq '*') {
            $v++;
            $key = "*";
          }
        } else {
          if ($v == 0) {
            print $info $display_list[$v];
            $no_print++;
          } else {
            if ($strip_space == 0) {
              print $info " ".$display_list[$v];
              $no_print++;
            } else {
              print $info $display_list[$v];
              $no_print++;
            }
          }
          $key = $display_list[$v];
          $v++;
        }
# The end comment or the number
        if (($key eq "*") || ($key eq "@")) {
          if ($key eq "@") {
            print $info $vals[$w];
            $no_print++;
          } else {
            if ($no_comments == 1) {
              if ($repeat_comments eq "1") {
                print $info $comment_char.$vals[$w];
                $no_print++;
              } else {
                if ($last_comment ne $vals[$w]) {
                  print $info $comment_char.$vals[$w];
                  $last_comment = $vals[$w];
                  $no_print++;
                }
              }
            }
          }
        } else {
          my $working = sprintf($yaml->[0]->{$key}->{format},$vals[$w]);
          $working =~ tr/ /0/s;
          if ( exists $yaml->[0]->{$key}->{signed}) {
            if ($yaml->[0]->{$key}->{signed} eq '1') {
              if ( exists $yaml->[0]->{$key}->{positive}) {
                if (($yaml->[0]->{$key}->{positive} eq '1') && ($vals[$w] > 0)) { $working = "+".$working; }
              }
            }
          }
          if (exists $yaml->[0]->{$key}->{strip}) {
            if (($yaml->[0]->{$key}->{strip} eq "lt") || ($yaml->[0]->{$key}->{strip} eq "t")) {
              $working =~ s/\.(?:|.*[^0]\K)0*\z//;
            }
            if (($yaml->[0]->{$key}->{strip} eq "lt") || ($yaml->[0]->{$key}->{strip} eq "l")) {
              $working =~ s/^0+(?=[0-9])//;
            }
          }
          print $info $working;
          $no_print++;
        }
        $w++;
     }
     if (($drop_blanks eq "1") && ($no_print != 0)) {
       print $info "\n";
     } else {
       print $info "\n";
     }
     $no_print = 0;
   } else {
     if ($drop_blanks ne "1") {
       print $info "\n";
     }
   }
   if ($Debug) {
     print $info "Hit ENTER to continue...\n";
     <STDIN>;
   }
}

close $info;

exit;

sub Do_Parse {

  my @pieces;
  my $line = shift;
  my $spec_flag = 0;
  for (my $ff=0;$ff<@lookout;$ff+=2) {
    if (index($line, $lookout[$ff]) != -1) {
# search line for  name
      if ($Debug) { print "Found Special! ".$lookout[$ff]."\n"; }
      if ($lookout[$ff+1] ne "") {
# process like    equal
        $pieces[0] = "@".$ff;
        $line =~ s/$lookout[$ff]/$lookout[$ff+1]/;
      } else {
# if equals  null - leave line alone
        $pieces[0] = "@".$ff;
        $pieces[1] = $line;
        return @pieces;
      }
      $spec_flag++;
    }
  }
  if ($spec_flag > 0) {
    if ($Debug) {
      print "Special - ".$line."\n";
      print "Hit ENTER to continue...\n";
      <STDIN>;
    }
    $spec_flag = 0;
  }

  my $drop_flag = 0;
  for (my $ff=0;$ff<@droplist;$ff+=2) {
    if (index($line, $droplist[$ff]) != -1) {
# search line for  name
      if ($Debug) { print "Found Drops! ".$droplist[$ff]."\n"; }
      $droplist[$ff+1]--;
      if ($droplist[$ff+1] == 0) {
# process the drop
        $pieces[0] = "";
        $line = "";
        return @pieces;
      }
# if equals  null - leave line alone
      $drop_flag++;
    }
  }
  if ($drop_flag > 0) {
    if ($Debug) {
      print "Drop - ".$line."\n";
      print "Hit ENTER to continue...\n";
      <STDIN>;
    }
    $drop_flag = 0;
  }

  my @bits = split($comment_char,$line);
  my $count = @bits;
  my @characters;
  my $j = 0;

# 0 blank line
# 1 no comment
# 2 some comment or all comment

  if ($count == 0) {
    $pieces[0]="";
  } else {
    if ($count == 1) {
# process
#      print $bits[0]."\n";
      @characters = split(//,$bits[0]);
      for (my $i=0;$i<@characters;$i++) {
# it's a number
        if ( $characters[$i] =~ /[0123.+-4567890]/ ) {
          $pieces[$j] .= $characters[$i];
#          print "###".$j."==".$pieces[$j]."\n";
        } else {
# it ain't a number
          if ( $characters[$i] ne ' ' ) {
            $pieces[0] .= $characters[$i];
            $j++;
          }
        }
      }

    } else {
      if (($count == 2) && (length($bits[0]) > 1) ) {
#process
#        print $bits[0];
        @characters = split(//,$bits[0]);
        for (my $i=0;$i<@characters;$i++) {
# it's a number
#          print ">".$characters[$i]."<\n";
          if ( $characters[$i] =~ /[123.+-4567890]/ ) {
            $pieces[$j] .= $characters[$i];
#            print "###".$j."==".$pieces[$j]."\n";
          } else {
# it ain't a number
            if ( $characters[$i] ne ' ' ) {
              $pieces[0] .= $characters[$i];
              $j++;
            }
          }
        }

        $pieces[0] .= "*";
        push(@pieces,$bits[1]);
      } else {
        $pieces[0]="*";
        $pieces[1]=$bits[1];
      }
    }
  }
  return @pieces;
}
