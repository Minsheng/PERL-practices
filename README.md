PERL-practices
==============

+Practices in PERL+

Edited by Minsheng Zheng on May 30, 2013
Environment:
OS - Windows 7;
IDE - Eclipse + EPIC;
Database - MySQL Server 5.6, MySQL Workbench 5.2CE, DBI, DBD::mysql;

Detailed instructions
---------------------
The goal is to write a PERL script in order
to update a table we defined as "count_tbl" based on the data from
another table "mailing," stored with over 10000000 email address
and grows daily with hundreds or thousands of new addresses.

DB.pm is a module provided to us that defined two functions "dbConnect" and "query"
for establishing connection to a MySQL database and processing queries.

First of all, we need to run a script for initializing the database "test" with
an empty table "mailing" and another self-defined table "count_tbl", by running
"initDB.sql."

Secondly, we populate some test data or random email addresses into the database
by running "genTestData.pl."

Now we have some sample data in the test database, the next step is
to run "updateCount.pl" to update the table "count_tbl" with recent
count of domain names.

Finally, we can run "reportTOP.pl" and we will be able to see the top N
records printed to the Console, in descending order. A sample would be like
this, in descending order:

gmail.com - 14.4444444444444
casalemedia.com - 12.5
hotmail.com - 10.5
amazon.com - 4.25
rogers.com - 3.57142857142857

(In real-life the percentage will be much smaller because the base table "mailing"
is extremely large and the growth of number of email addresses in a short 
period of time is not that significant compared to existing data.)


Performance issue and alternative solution
------------------------------------------
Since we have at least 100000 domain names, and for each day we need to count all of them once,
this table is going to grow by at least 100000 rows everyday, resulting into a table with at least
36500000 rows after a year. A solution would be to horizontally partition the table by days periodically. 
This will increase processing speed since each partitioned table is only with at least 100000 rows,
compared to 36500000 rows. 


Core components:
----------------

### updateCount.pl
This script keeps track of daily count of each single domain name.

To be optimized:
String records and count are copied into hash array and result into in-memory process.
This could be inefficient when there are 10000000 records and each may take at least 100 bytes, resulting
in at least 9GB data. 

Alternative implementation could be:
- fetch part of the data, process them and INSERT count of partial data into count_tbl
- fetch next part of data, UPDATE count into count_tbl, until all the email addresses are counted

### reportTOP.pl
This script computes growth rate and hash (domain name, growth rate) pair
into a hash array. Then it output the top N records while sorting
the hash array by values in descending order. Sorting algorithm for large
hash is not efficient as well. The "sort" we used is simply PERL's built-in function and
takes O(n*logn).

Alternative solutions to sorting:
- Write all the data to a .db file which has B-TREE INDEX on the values or growth rates.
- Lookup, Insertion and especially sequentially access will benefit since it only takes O(logn) now
