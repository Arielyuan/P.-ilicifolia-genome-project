#!/usr/bin/perl -w
use strict;
my $denovo_gff = shift;
my $homolog_gff = shift;
my $evm_gff = shift;
my $op = shift;
open (I1,"<$denovo_gff") or die ("$!\n");
open (I2,"<$homolog_gff") or die ("$!\n");
open (I3,"<$evm_gff") or die ("$!\n");
open (O,">$op") or die ("$!\n");

my %denovo;
while (my $eve = <I1>){
    chomp ($eve);
    my @a = split/\s+/,$eve;
    my $scaffold_name = $a[0];
    my $start = $a[3];
    my $end = $a[4];
    for (my $i=$start;$i<=$end;$i++){
	$denovo{$scaffold_name}{denovo}{$i}++;
#	$hash{$scaffold_name}{homolog}{$i}++;
    }
}

my %homolog;
while (my $eve = <I2>){
    chomp ($eve);
    my @a = split/\s+/,$eve;
    my $scaffold_name = $a[0];
    my $start = $a[3];
    my $end = $a[4];
    for (my $i=$start;$i<=$end;$i++){
        $homolog{$scaffold_name}{homolog}{$i}++;
    }
}

my $gene_id = 0;
while (my $eve= <I3>){
    chomp ($eve);
    my @a = split/\s+/,$eve;
    my $scaffold_name = $a[0];
    my $type = $a[2];
    my $start = $a[3];
    my $end = $a[4];
    if ($type eq "mRNA"){
	my $length = ($end-$start+1);
	for (my $i=$start;$i<=$end;$i++){
	    if exits 
	}
    }

	
    }
