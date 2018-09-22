#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_count = shift;
open (F,"<$gff_file") or die ("$!\n");
open (O,">$op_count") or die ("$!\n");

my %hash;
my $totalnum;
while (my $eve = <F>){
    chomp ($eve);
    my $gene_name;
    my @a = split /\s+/,$eve;
    my $type = $a[2];
    my $score = $a[5];
    if ($a[8] =~ /(.+)=(.+)/){
	$gene_name = $2;
    }
    if ($type eq "CDS"){
	$hash{$gene_name}{cds_length} += ($a[4]-$a[3]+1);
    }else{
	$hash{$gene_name}{mRNA_score} = $score;
    }
}
close F;
foreach my $gene_name (sort keys %hash){
    print O "$hash{$gene_name}{mRNA_score}\t$hash{$gene_name}{cds_length}\t\n";
}
close O;
