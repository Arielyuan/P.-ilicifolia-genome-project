#!/usr/bin/perl -w
#此脚本用来检测gff文件中mRNA有无开始位置小于0或结束位置大于sequence长度的情况
use strict;
use Bio::SeqIO;
use Bio::Seq;
my $genome_fa = shift;
my $gff = shift;
my $fa = Bio::SeqIO->new(-file=>$genome_fa, -format=>'fasta');
my %hash;
open (F,"<$gff") or die ("$!\n");
while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    my $length = length($seq);
    $hash{$id} = $length;
}
while (my $eve = <F>){
    chomp($eve);
    my @infor = split/\s+/,$eve;
    my $scaffold_name = $infor[0];
    my $type = $infor[2];
    if ($type eq "mRNA"){
	my $start = $infor[3];
	my $end = $infor[4];
	if (($start<0) || ($end>$hash{$scaffold_name})){
	    print "$eve\n";
	}
    }else{
	next;
    }
}
close F;
