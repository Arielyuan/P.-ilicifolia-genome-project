#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $file=shift;
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
while(my $seq = $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $fastafile = $id.".fa";
    open (F,">$fastafile") || die ("$!\n");
    print F ">$id\n$seq\n";
    close F;
}
