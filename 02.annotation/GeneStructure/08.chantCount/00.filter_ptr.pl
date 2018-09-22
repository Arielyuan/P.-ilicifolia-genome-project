#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_gff = shift;

open (F,"<$gff_file") or die ("$!\n");
open (O,">$op_gff") or die ("$!\n");
my %hash;
while (my $eve = <F>){
    chomp($eve);
    next if ($eve =~ /^\#/);
    my @a = (split/\s+/,$eve);
    if ($a[2] eq "transcript"){
#ID=transcript:POPTR_0001s00200.1;
	$a[8]=~/ID=transcript:(([^\.]+)\.(\d+));/;
	# $a[8] =~/ID=transcript:([^\;]+);/;
	my $mrna_id = $1;
	my $gene_name=$2;
#	print "$mrna_id\t$gene_name\t\n";
	$hash{$gene_name}{$mrna_id}{mRNAgff} = "$a[0]\t$a[1]\tmRNA\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$a[8]\t\n";
    }elsif ($a[2] eq "CDS"){
	$a[8]=~/ID=CDS:(([^\.]+)\.(\d+));/;
	my $mrna_id = $1;
        my $gene_name=$2;
	$hash{$gene_name}{$mrna_id}{CDSgff} .= "$eve\n";
	$hash{$gene_name}{$mrna_id}{cds_length} += ($a[4]-$a[3]);
    }else{
	next;
#	print "$eve\n";
    }
}

foreach my $gene_name (sort keys %hash){
#比较键值的大小：sort {$hash{$a}{value} <=> $hash{$b}{value}} keys %hash($a和$b就是mrna_id)
    my @mrna_id = sort {$hash{$gene_name}{$b}{cds_length} <=> $hash{$gene_name}{$a}{cds_length}} keys %{$hash{$gene_name}};
    my $mrna_id=$mrna_id[0];
    print O "$hash{$gene_name}{$mrna_id}{mRNAgff}";
    print O "$hash{$gene_name}{$mrna_id}{CDSgff}";
}
close F;
close O;
