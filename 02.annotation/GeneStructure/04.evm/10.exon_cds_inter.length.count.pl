#!/usr/bin/perl -w
use strict;
my $op_count = "10.exon_cds_inter.length.count";
my $standard_gff = "09.pil.evm.33684.gff";
my $genome = "399970306";
open (O,">$op_count") or die ("$!\n");
print O "Gene\tper\tExon\tper\tIntron\tper\tIntergenitic\tper\n";
open (F,"<$standard_gff") or die ("$!\n");
my $gene_length;
my $cds_length;
while(my $eve = <F>){
    my @infor = split /\s+/,$eve;
    my $type = $infor[2];
    if ($infor[2] eq "mRNA"){
	$gene_length += ($infor[4]-$infor[3]+1);
    }elsif($infor[2] eq "CDS"){
	$cds_length += ($infor[4]-$infor[3]+1);
    }else{
	next;
    }
}
my $intron_length = $gene_length-$cds_length;
my $intergenitic = $genome - $gene_length;
my $gene_per = $gene_length/$genome;
my $exon_per = $cds_length/$genome;
my $intron_per = $intron_length/$genome;
my $inter_per = $intergenitic/$genome;
print O "$gene_length\t$gene_per\t$cds_length\t$exon_per\t$intron_length\t$intron_per\t$intergenitic\t$inter_per\n";
close F;
close O;
