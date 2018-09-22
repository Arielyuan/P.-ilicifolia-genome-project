#!/usr/bin/perl -w
use strict;
my $input = "01.swissprot_blastp.out";
my $output = "04.swissprot.count.txt";

open(I,"<$input") or die ("$!\n");
open (O,">$output") or die ("$!\n");

my %hash;
my $total_gene = 33684;
my $valid_gene;
while (my $eve = <I>){
    chomp($eve);
    my @a = split/\s+/,$eve;
    my $gene_id = $a[0];
    my $match_pro = $a[1];
    $hash{$gene_id}{$match_pro}++;
}

foreach my $gene_id (sort keys %hash){
    $valid_gene++;
    print "$gene_id\n";
}
my $percent = $valid_gene/$total_gene;
print O "total_num\nmatched_num\tpercent\t\n";
print O "$total_gene\t$valid_gene\t$percent\t\n";

close I;
close O;
