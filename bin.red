#!/usr/local/bin/perl
# -*- perl -*-

# Copyright (c) 2001 by Jeff Weisberg
# Author: Jeff Weisberg <jaw @ tcp4me.com>
# Function: colorize logfile output

# typical use:
#  tail -f logfile | red -g something &
#  tail -f logfile | red -g otherthing -blue &



use Getopt::Long;

$color = "1;31";
$attr  = '';

GetOptions( "g=s@"   => \@grep,
	    "v=s@"   => \@expt,
	    "i"      => \$opt_i,
	    "red"    => sub { $color = "1;31" },
	    "blue"   => sub { $color = "1;34" },
	    "green"  => sub { $color = "32"   },
	    "purple" => sub { $color = "1;35" }, # technically this is "magenta"
	    "magenta"=> sub { $color = "1;35" }, # we allow either name...
	    "cyan"   => sub { $color = "36"   },
	    "yellow" => sub { $color = "33"   },
	    "none"   => sub { $color = "30"   },
	    "blink"  => sub { $attr .= "5;"   }, # not implemented in xterm
	    "reverse"=> sub { $attr .= "7;"   },
	    "underline" => sub { $attr .= "4;" },
	    "color=s"=> sub { shift; $color = shift; },
	    "help|?" => \&usage,
	    );

$| = 1;
LOOP: while(<>){
    chop;
    if( $opt_i ){
	foreach $v (@expt){ next LOOP if  /$v/i };
	foreach $g (@grep){ next LOOP if !/$g/i };
    }else{
	foreach $v (@expt){ next LOOP if  /$v/ };
	foreach $g (@grep){ next LOOP if !/$g/ }; 
    }
    print "\e\[${attr}${color}m$_\e\[0m\n";

}

sub usage {
    print STDERR <<EOH;
  -g pattern	print lines matching pattern (think "grep")
  -v pattern	skip lines matching pattern (think "grep -v")
  -i            case independant
  -blue		\\
  -green	|
  -purple	|
  -yellow	|  use the specified color instead of red
  -magenta	|
  -cyan		|
  -none         /
  -underline	underline
  -reverse	use reverse video
  -blink          annoy mode (does not work in an xterm)
  -color=spec	use the specified ANSI sequence for the color
  -help		do not print this message

  both "-g" and "-v" may be specified multiple times
  ex: tail -f logfile | red -blue -underline -g capri -g named -v netreach
EOH
    ;
    exit;
}

