#!/usr/bin/perl -w
# this script used for take out one fasta that you want from a genome file.
use strict;
use Bio::SeqIO;

my $fasta = shift;
my $target = shift;

my $fa=Bio::SeqIO->new(-file=>$fasta,-format=>'fasta');

while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    if ($id eq $target){
	print ">$id\n$seq\n";
	last;
    }
}
