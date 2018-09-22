#! /usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $file=shift;
`mkdir 04.genome_split`;

my $in=Bio::SeqIO->new(-file=>$file,-format=>'fasta');
while(my $s=$in->next_seq){
    my $id=$s->id;
    my $seq=$s->seq;
    my $outfile="./04.genome_split/$id.fa";
    open(OUT,"> $outfile")||die("Cannot creat $outfile!\n");
    print OUT ">$id\n$seq\n";
    close OUT;
}
