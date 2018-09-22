#!/usr/bin/perl -w
#此脚本用来将每个基因负链cds的顺序从大到小排列输出
use strict;
my $gff_file = shift;
my $op_gff = shift;
open (O,">$op_gff") or die ("$!\n");
open (F,"<$gff_file") or die ("$!\n");
my %hash;
while(my $eve = <F>){
    my $key;
    chomp($eve);
    my @infor = split /\s+/,$eve;
    my $gene_name = $infor[8];
    my $strand = $infor[6];
    if($gene_name =~ /(\w+)\=(.+)/){
	$key = $2;
	 print "$key\n";
    }
    $hash{$key}{strand} = $strand;
    my $neweve = join "\t", @infor;
    if($infor[2] eq "mRNA"){
	$hash{$key}{mRNA} = $neweve."\n";
    }elsif($infor[2] eq "CDS"){
	$hash{$key}{CDS}{$infor[3]} = $neweve."\n";
    }
}

foreach my $gene(sort keys %hash){
    print O "$hash{$gene}{mRNA}";
    if ($hash{$gene}{strand} eq "+"){
	foreach my $start (sort {$a<=>$b} keys %{$hash{$gene}{CDS}}){
	    print O "$hash{$gene}{CDS}{$start}";
	}
    }elsif($hash{$gene}{strand} eq "-"){
	foreach my $start (sort {$b<=>$a} keys %{$hash{$gene}{CDS}}){
	    print O "$hash{$gene}{CDS}{$start}";
	}
    }
}

close F;
close O;
