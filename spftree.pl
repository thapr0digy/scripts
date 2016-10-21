#!/usr/bin/perl

use strict;
use warnings;

use Net::DNS;
use Net::IP;
use Data::Dumper qw(Dumper);

my $host = $ARGV[0];
my @responses;
my $findip = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
my $spaces = "    ";
my $ip = $ARGV[1];
my ($found,$hostrecord);

print "\nDomain: $host\n";
print "Searching for IP: $ip\n\n";

sub findIPMatch {
    my ($checkip, $range) = @_;
    my $testip = new Net::IP($checkip) || die;
    my $testrange = new Net::IP($range) || die;
    
    if ($testip->overlaps($testrange) == $IP_A_IN_B_OVERLAP) {
    	print "They overlap A in B\n";
	exit;
    } elsif ($testip->overlaps($testrange) == $IP_B_IN_A_OVERLAP) {
	print "They overlap B in A\n";
        exit;
    } else {
	print "They don't overlap!\n";
	exit;
    }

}
sub findRecord {

    my ($search, $count) = @_;
    my $res = Net::DNS::Resolver->new;
    my $reply = $res->query($search, "TXT");
    my $spf;
    my (@includes, @ips);
    	
    if ($reply) {
    	foreach my $rr ($reply->answer) {
		next unless $rr->string =~ /(v=spf[^"]+)/;
		$spf = $1;
    	}
    }		
    
    @ips = $spf =~ /(?:(?:ip[46]:)|(?:a:))(\S+)/smg;
    print "IPS: $_ " foreach @ips;
    print "\n";
    #foreach my $myiprange (@ips) {
    #	findIPMatch($ip, $myiprange);
    #} 
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
#findIPMatch("8.8.8.8","199.122.121.0/24");
findRecord($host, 2);
print "Found IP\n----------------\n$hostrecord\n\t$found\n";
