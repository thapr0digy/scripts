#!/usr/bin/perl

use strict;
use warnings;

use GetOpt::Long qw(GetOptions);
use URI::Encode;

my ($encode, $decode, $help);

GetOptions('e=s => \$encode,
            d=s => \$decode,
            h => \$help' ) or die "Usage: $0 -e <value> -d <value> -h\n";

my $uri = URI::Encode->new( { encode_reserved => 0 } );
