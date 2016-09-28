#!/opt/proofpoint/current/opt/perl/bin/perl

use strict;
use warnings;

use Net::DNS;
use Data::Dumper qw(Dumper);

my $host = $ARGV[0];
my @responses;
my $findip = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $countspace = 1;
my $spaces = " " x $countspace;

print "\n$host\n";

sub findRecord {

    my ($search) = @_;
    my $res = Net::DNS::Resolver->new;
    my $reply = $res->query($search, "TXT");
    my $spf;
    my @includes;
    
    print "$spaces-> $search\n";

    if ($reply) {
    	foreach my $rr ($reply->answer) {
		next unless $rr->string =~ /(v=spf[^"]+)/;
		$spf = $1;
    	}
		
	@includes = $spf =~ /include:(\S+)/smg;
	print "$spaces-> $spf\n\n";

    	$spaces = " " x $countspace++;
	
	foreach my $domain (@includes) {
		findRecord($domain);
	}
    	#my @records = split(" ",$spf);

    	#foreach (@records) {
	#	print "\t-> $_\n" if /$findip/; 
	#	findRecord($1) if /include:(\S+)/;
    	#}
    
    }

}
findRecord($host);
