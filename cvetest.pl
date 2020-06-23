#!/usr/bin/perl

use HTML::TreeBuilder;
use List::MoreUtils qw(zip);

my @source = ();
my @status = ();
my %results = ();

$html = HTML::TreeBuilder->new_from_content(<STDIN>) or die $!;

foreach ($html->look_down(_tag => "div", class => "value")) {
	$node = $_;
	if ($node->as_text() =~ /^Source: ([^(]+)/) {
		push @source, $1;
	}
}
foreach $h ($html->look_down(_tag => "table")) {
	$node = $h;
	foreach $tr_node ($node->look_down(_tag => "tr")) {
		foreach $td_node ($tr_node->find_by_tag_name("td")) {
            $text = $td_node->as_text();
            if ($text =~ /^Ubuntu 16.04/) {
			    $match = $tr_node->look_down(_tag => "span");
                push @status, $match->as_text();
            }
        }
   }
}
my %cvehash;
@cvehash{@source} = @status;

foreach (sort keys %cvehash) {
    if ($cvehash{$_} =~ /^need/) {
        print "Not fixed! Check package: $_\n";
    } elsif (!defined $cvehash{$_}) {
        print "NOT FOUND. Check CVE!\n";
    } else {
        print "$_ - $cvehash{$_}\n";
    }
}
