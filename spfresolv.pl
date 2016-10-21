#!/usr/bin/perl

use strict;
use warnings;

use Net::DNS;
use Data::Dumper qw(Dumper);

my $host = $ARGV[0];
my @responses;
my $findip = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

sub findRecord {

    my ($search) = @_;
    print "\n$search\n";
    my $res = Net::DNS::Resolver->new;
    my $reply = $res->query($search, "TXT");
    my $spf;

    if ($reply) {
    	foreach my $rr ($reply->answer) {
		next unless $rr->string =~ /(v=spf[^"]+)/;
		$spf = $1;
    	}
    	my @records = split(" ",$spf);
    	#my @nr;
    	foreach (@records) {
		print "\t-> $_\n" if /$findip/; 
		findRecord($1) if /include:(\S+)/;
		#push @nr, "\t-> $1" if /include:(\S+)/;
    	}
    	#print "$_\n" foreach @nr;
    }

}
findRecord($host);
