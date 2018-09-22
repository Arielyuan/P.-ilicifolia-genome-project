#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $file="ppr.cds";
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
my $op = "ppr.rename.cds";
open (O,">$op") or die ("$!\n");
while(my $seq = $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $newid = "ppr_".$id;
    print O ">$newid\n$seq\n";
}
close O;
