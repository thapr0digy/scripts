#!/usr/bin/perl

use strict;
use warnings;

use MIME::Parser;
use Data::Dumper;

sub usage() {
    print "Usage: $0 <file.eml>\n";
    exit 1;
}

usage() if($#ARGV+1 < 1);

my $email = $ARGV[0];
open(my $fh,"< $email") or die "Cannot open $email for processing!!\n";

my $outdir = "./attachments";

if ( -e $outdir and -d $outdir) {
    print "Outputting attachments to $outdir...\n";
} else {
    print "Creating $outdir directory...\n";
    mkdir($outdir);
}

my $parser = new MIME::Parser;
$parser->output_dir($outdir); 
#$parser->output_to_core(0);

my $entity = $parser->parse($fh); 
$fh->close();
