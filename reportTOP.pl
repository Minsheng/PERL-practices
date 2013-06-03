#!/usr/bin/perl -w

use strict;
use warnings;
use DB;

my $dbh = dbConnect();

my $sql = "SELECT * FROM count_tbl where count_date = CURDATE()";
my $sql_old = "SELECT * FROM count_tbl where count_date = DATE_SUB(CURDATE(), INTERVAL 1 MONTH)";
my @result = query($dbh, $sql);
my @result_old = query($dbh, $sql_old);
my $top = 50; # this can be changed in order to return more records
my %growth_tbl = ();

# hash data with current date into growth_tbl
foreach (@result) {
  my @row = values %$_;
	$growth_tbl{$row[2]} = $row[1]; # (domain_name, count) pair 

}

# update growth_tbl with growth rate
foreach (@result_old) {
	my @row = values %$_;
	
	# if the same domain name is found, replace the count value with newly calculated growth rate
	if (exists($growth_tbl{$row[2]})) {
		$growth_tbl{$row[2]} = abs($growth_tbl{$row[2]} - $row[1]) / $row[1];
	}
}

for my $key (sort { $growth_tbl{$b} <=> $growth_tbl{$a} } keys %growth_tbl) {
	if ($top == 0) {last;}
	printf "%s - %s\n", $key, $growth_tbl{$key};
	$top--;
}

$dbh->disconnect();

exit;
