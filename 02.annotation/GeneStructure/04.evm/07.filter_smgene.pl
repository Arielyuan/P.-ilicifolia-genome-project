#!/usr/bin/perl -w
use strict;
my $ip_gff = shift;
my $op_filtered_gff = shift;
open (F,"<$ip_gff") or die ("$!\n");
open (O,">$op_filtered_gff") or die ("$!\n");
my %hash;
while(my $eve = <F>){
    chomp($eve);
    if ($eve =~/^scaffold/){
	my @infor = split /\s+/,$eve;
	my $gene_name;
#如果此脚本用于evm跑完之后结果的过滤，取消下面几行注释
        #ID=evm.TU.scaffold10012_cov116.1
	if ($infor[8]=~/(.+)=(.+)\.(.+)\.(.+);/){
	    $gene_name = $4;
	}

#如果此脚本用于跑evm之前的homolog或者denovo的结果的话，取消下面几行的注释
#       #ID=ath-scaffold1003_cov113-1; Parent=ath-scaffold1003_cov113-1;
#	if ($infor[8]=~/(.+)=(.+);/){
#           $gene_name = $2;
#	}


	my $start = $infor[3];
	my $end = $infor[4];
	if ($infor[2] eq "CDS"){
	    $hash{$gene_name}{cds_length} += ($end - $start +1);
	}
	if ($infor[2] eq "mRNA" || $infor[2] eq "CDS"){
	    $hash{$gene_name}{gff}.=$eve."\n";
	}
    }
}
close F;
foreach my $gene_name(sort keys %hash){
#    print "$hash{$gene_name}{cds_length}\n";
    if($hash{$gene_name}{cds_length}!~/^\d+$/){
	print "$gene_name\n$hash{$gene_name}{cds_length}\n";
	die();
    }
    if ($hash{$gene_name}{cds_length} >= 100){
	print O "$hash{$gene_name}{gff}";
    }
}
close O;
