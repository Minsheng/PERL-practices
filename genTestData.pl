#!/usr/bin/perl -w
#
# generate a small dataset such that
# each domain name has a random number of different email addresses
#

use strict;
use warnings;
use DB;

my $dbh = dbConnect();
my $sql = "INSERT INTO mailing(addr) VALUES (?)";

my $addr_prefix = "user";
my $prefix_num = 1;
# some random domain names
my @addr_domain = qw/casalemedia.com gmail.com amazon.com hotmail.com rogers.com ibm.com yahoo.com/;
my $entries = "";

my $range = 200;
my $min = 5; # add a minimum in case generating 0

foreach (@addr_domain) {
  my $rand_upper = int(rand($range)) + $min;
	my $j = 0;
	
	# generate a random numbers of addresses for each domain name
	while ($j < $rand_upper) {
		# create an email address (ex. user1@gmail.com)
		my $addr_sample = $addr_prefix . $j . '@' . $_;
		query($dbh, $sql, $addr_sample);
		$j++;
	}
}

$dbh->disconnect();

exit;
