#!/usr/bin/perl -w
#此脚本计算了每一个深度下对应的碱基数目，需要将$path改为自己的samtools的路径
#基因组fasta文件 bam文件 输出文件
use strict;
use Bio::SeqIO;
my $path = "/share/work/user124/software/02.genome_assemble/sametools/samtools/samtools";
my $fasta = shift;
my $bam = shift;
my $op = shift;
my %hash;
open (O,">$op") ||die ("$!\n");
my $fa = Bio::SeqIO->new(-file=>$fasta, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    open (I,"$path depth -r $id $bam |");
    while(my $eve = <I>){
	chomp ($eve);
	my @infor = split/\t/,$eve;
	my $depth = $infor[2];
	$hash{$depth}++;
    }
    close I;
}
foreach my $depth (sort {$a<=>$b} keys %hash){
    print O "$depth\t$hash{$depth}\n";
}
close O;
