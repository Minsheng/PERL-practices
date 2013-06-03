#!/usr/bin/perl -w

use strict;
use warnings;
use DB;

my $dbh = dbConnect();

# Create an array that holds references to all the rows
# in 'mailing', each element is a hash
my $sql = "SELECT * FROM mailing";
my @result = query($dbh, $sql);

# A hash array for storing (domain_name, num_addr) pair
my %domain_count = ();

foreach (@result) {
  my @row = values %$_; # copy the addr in a temp array
	my @ele = split(/(.*)@(.*)$/, $row[0]); # get the domain name, the first ele is empty string
	
	# keep track of the numbers of addrs for each domain name
	# in a hash array
	if (exists($domain_count{$ele[2]})) {
		$domain_count{$ele[2]} += 1;
	} else {
		$domain_count{$ele[2]} = 1;
	}
}

# update the count table with domain name counts with the current date
foreach my $key (keys %domain_count) {
	$sql = "INSERT INTO count_tbl(do_name, num_addr, count_date) VALUES (?, ?, CURDATE())";
	query($dbh, $sql, $key, $domain_count{$key});
}

$dbh->disconnect();

exit;
