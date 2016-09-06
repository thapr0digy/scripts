#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Getopt::Long qw(GetOptions);
use URI::Encode qw(uri_encode uri_decode);

my $encode;
my $decode;

GetOptions('encode=s' => \$encode,
           'decode=s' => \$decode
          ) or die "Usage: $0 -e <value> -d <value>\n";

my $uri = URI::Encode->new( { encode_reserved => 1 } );

if($encode) {
    
    print "Value: $encode\n"; 
    my $encoded = $uri->encode($encode);
    print "Encoded: $encoded\n";
    exit;

} elsif($decode) { 
    
    print "Value: $decode\n";
    my $decoded = $uri->decode($decode);
    print "Decoded: $decoded\n";
    exit;

}
