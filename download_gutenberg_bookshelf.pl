#!/usr/bin/perl

use LWP::Simple;
use strict;


# Return first met plain text URL
sub get_plaintext_url {
	my $url = shift;
	my $data = get($url);
	return $1 if ($data=~m%href="([^"]+)".*?title="Download from ibiblio.org.">Plain Text U%mg);
}

# Return all URLs to books
sub get_bookshelf_urls {
	my $url = shift;
	my $data = get($url);
	my @ret = ();
	# TODO: ignore Audio books and other non-text
	while($data=~m%<a href="([^"]+)" class="extiw"%gs) {
		push @ret, $1;
	}
	return @ret;
}

# Download all books from this bookshelf
my $url = 'http://www.gutenberg.org/wiki/Category:Religion_Bookshelf';
my @bookshelf = get_bookshelf_urls($url);
foreach my $book (@bookshelf) {
	my $plain_url = get_plaintext_url($book);
	if ($plain_url=~m%/([^/]+)$%) {
		my $filename = $1;
		# Go to next if the file already exists
		next if (-s $filename > 1024);
		my $data = get($plain_url);
		if ($data) {
			print "Saving $plain_url into $filename\n";
			open (FILE, ">$filename") or die ("Cannot write $filename: $!");
			print FILE $data;
			close(FILE);
			# Sleep one minute between books, otherwise gutenberg bans your IP!
			sleep 60;
		}
	}
}
