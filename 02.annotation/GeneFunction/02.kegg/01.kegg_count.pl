#!/usr/bin/perl -w
use strict;
my $input = shift;
my $output = shift;

open(I,"<$input") or die ("$!\n");
open (O,">$output") or die ("$!\n");

my %hash;
my $total_gene;
my $valid_gene;
while (my $eve = <I>){
    chomp($eve);
    $total_gene++;
    my @a = split/\s+/,$eve;
    my $a_num = scalar @a;
    if ($a_num == 2){
	$valid_gene++;
	my $gene_id = $a[0];
	my $kegg_tab = $a[1];
	print "$gene_id\n";
	$hash{$gene_id}=$kegg_tab;
    }else{
	next;
    }
}
my $percent = $valid_gene/$total_gene;
print O "total_num\tkegg_num\tpercent\t\n";
print O "$total_gene\t$valid_gene\t$percent\t\n";
