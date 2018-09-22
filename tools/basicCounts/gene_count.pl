#!/usr/bin/perl -w
use strict;
my $op_count = shift;
my @standard_gff = @ARGV;
open (O,">$op_count") or die ("$!\n");
print O "Gene set\tNumber\tAverge transcript length(bp)\tAverge CDs length(bp)\tAverage exon per gene\tAverage exon length(bp)\tAverge intron length(bp)\t\n";
#04-5-3.rco.filter_overlap.gff
for (my $j=0;$j<@standard_gff;$j++){
    my $gene_set;
    open (F,"<$standard_gff[$j]") or die ("$!\n");
    if($standard_gff[$j] =~ /([\d-]+)\.(\w+)\.*/){
	$gene_set = $2;
    }
    my $gene_num;
    my $gene_length;
    my $cds_num;
    my $cds_length;
    my $intron_num;
    my $intron_length;
    my $exon_num;
    while(my $eve = <F>){
	my @infor = split /\t/,$eve;
	my $type = $infor[2];
	if ($infor[2] eq "mRNA"){
	    $gene_num++;
	    $gene_length += ($infor[4]-$infor[3]+1);
	}elsif($infor[2] eq "CDS"){
	    $cds_num++;
	    $cds_length += ($infor[4]-$infor[3]+1);
	}else{
	    print "wrong!";
	    last;
	}
    }
    my $ev_trans_length = $gene_length/$gene_num;
    my $ev_cds_length = $cds_length/$gene_num;
    my $ev_ex_per_gene = $cds_num/$gene_num;
    my $ev_exon_length = $cds_length/$cds_num;
    my $ev_intron_length = ($gene_length-$cds_length)/($cds_num-$gene_num);
    print O "$gene_set\t$gene_num\t$ev_trans_length\t$ev_cds_length\t$ev_ex_per_gene\t$ev_exon_length\t$ev_intron_length\t\n";
    close F;
}
close O;
