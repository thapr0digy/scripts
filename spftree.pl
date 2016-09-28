#!/opt/proofpoint/current/opt/perl/bin/perl

use strict;
use warnings;

use Net::DNS;
use Data::Dumper qw(Dumper);

my $host = $ARGV[0];
my @responses;
my $findip = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $spaces = "    ";

print "\nDomain: $host\n\n";

sub findRecord {

    my ($search, $count) = @_;
    my $res = Net::DNS::Resolver->new;
    my $reply = $res->query($search, "TXT");
    my $spf;
    my @includes;

    if ($reply) {
    	foreach my $rr ($reply->answer) {
		next unless $rr->string =~ /(v=spf[^"]+)/;
		$spf = $1;
    	}
    }		
	
    @includes = $spf =~ /include:(\S+)/smg;
    if(!@includes) {
	--$count;
	$spaces = "    " x $count;
    }
    print "$spaces-> $search\n";
    print "$spaces-> $spf\n\n";

    $spaces = "    " x $count++;

    foreach my $domain (@includes) {
	findRecord($domain, $count);
    }

    --$count;
}

findRecord($host, 2);
