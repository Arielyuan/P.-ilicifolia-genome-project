#!/usr/bin/perl -w
use strict;
my $input = "all.qurey.redundant.ko";
my $output = "02.pilnr.all.ko.tbl";

open(I,"<$input") or die ("$!\n");
open (O,">$output") or die ("$!\n");

my %hash;
my $total_gene;
my $valid_gene;
while (my $eve = <I>){
    chomp($eve);
    my @a = split/\s+/,$eve;
    my $a_num = scalar @a;
    if ($a_num == 2){
	my $gene_id = $a[0];
	my $kegg_tab = $a[1];
	$hash{$gene_id}{$kegg_tab}++;
    }else{
	next;
    }
}

foreach my $gene (sort keys %hash){
    my @line=($gene);
    foreach my $kegg_tab (sort keys %{$hash{$gene}}){
	push @line,$kegg_tab;
    }
    print O join "\t",@line,"\n";
}

close I;
close O;
