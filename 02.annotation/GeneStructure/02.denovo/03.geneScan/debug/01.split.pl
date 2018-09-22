#! /usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $file=shift;
`mkdir scaffolds` if(!-e "scaffolds");

my $in=Bio::SeqIO->new(-file=>$file,-format=>'fasta');
while(my $s=$in->next_seq){
    my $id=$s->id;
    my $seq=$s->seq;
    my $outfile="./scaffolds/$id.fa";
    open(OUT,"> $outfile")||die("Cannot creat $outfile!\n");
    print OUT ">$id\n$seq\n";
    close OUT;
}
