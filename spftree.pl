#!/opt/proofpoint/current/opt/perl/bin/perl

use strict;
use warnings;

use Net::DNS;
use Data::Dumper qw(Dumper);

my $host = $ARGV[0];
my @responses;
my $findip = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $spaces = "    ";
my $ip = $ARGV[1];
my ($found,$hostrecord);

print "\nDomain: $host\n";
print "Searching for IP: $ip\n\n";

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

    if ($spf =~ /$ip/) {
	$found = $spf;
	$hostrecord = $search;
    }	

    @includes = $spf =~ /include:(\S+)/smg;

    if (!@includes) {
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
print "Found IP\n----------------\n$hostrecord\n\t$found\n";
