#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_gff = shift;

open (F,"<$gff_file") or die ("$!\n");
open (O,">$op_gff") or die ("$!\n");
my %hash;
my $gene_no=0;
my $mrna_no=0;
while (my $eve = <F>){
    chomp($eve);
    next if ($eve =~ /^\#/);
    my @a = (split/\s+/,$eve);
    if ($a[2] eq "gene"){
	$gene_no ++;
    }elsif ($a[2] eq "mRNA"){
	$mrna_no++;
	$hash{$gene_no}{$mrna_no}{mRNAgff} = "$a[0]\t$a[1]\tmRNA\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[8]\t\n";
    }elsif ($a[2] eq "CDS"){
	$hash{$gene_no}{$mrna_no}{CDSgff} .= "$eve\n";
	$hash{$gene_no}{$mrna_no}{cds_length} += ($a[4]-$a[3]);
    }else{
	next;
    }
}

foreach my $gene_no (sort keys %hash){
#比较键值的大小：sort {$hash{$a}{value} <=> $hash{$b}{value}} keys %hash($a和$b就是mrna_id)
    my @mrna_no = sort {$hash{$gene_no}{$b}{cds_length} <=> $hash{$gene_no}{$a}{cds_length}} keys %{$hash{$gene_no}};
    my $longest_mrna_no=$mrna_no[0];
    print O "$hash{$gene_no}{$longest_mrna_no}{mRNAgff}";
    print O "$hash{$gene_no}{$longest_mrna_no}{CDSgff}";
}
close F;
close O;
