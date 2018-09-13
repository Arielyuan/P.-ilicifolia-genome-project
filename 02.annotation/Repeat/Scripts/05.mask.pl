#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my ($gff_file,$genome_file,$op1,$op2)=@ARGV;
die "Usage: $0 <gff file> <genome file> <output 1> <output 2>\n" if(@ARGV!=4);
#my $gff_file = shift;
#my $genome_file = shift;
#my $op1 = shift;#将重复序列替换成小写字母的输出文件
#my $op2 = shift;#将重复序列替换成N的输出文件
#if(@ARGV==4){
my %hash;

open (G, "<$gff_file") or die ("$! $gff_file\n");
open (O1, ">$op1") or die ("$! $op1\n");
open (O2, ">$op2") or die ("$! $op2\n");

#将所有的键值存起来第一层scaffold_name;第二层是重复序列的位置
#用包含所有重复序列信息的gff文件
while(my $eve = <G>){
    chomp($eve);
    my @infor = (split/\t/,$eve);
    my $scaffold_name = $infor[0];
    my $start = $infor[3];
    my $end = $infor[4];
    for (my $i=$start;$i<=$end;$i++){
	$hash{$scaffold_name}{$i}++;
    }
}
close G;

#输入基因组fasta文件，找到对应的位置，替换成1小写2n
my @newlowerbase;
my @newreplacebase;
my $newseq1;
my $newseq2;
my $lowerbase;
my $replacebase;
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my @base = split//,$seq;
    for (my $j=0;$j<=$#base;$j++){
	if (exists $hash{$id}{$j+1}){
	    $lowerbase = lc($base[$j]);
	    $replacebase = "n";
	}else{ 
	    $lowerbase = $base[$j];
	    $replacebase = $base[$j];
	}
	push(@newlowerbase,$lowerbase);
	push(@newreplacebase,$replacebase);
    }
    $newseq1 = join"", @newlowerbase;
    $newseq2 = join"", @newreplacebase;
    print O1 ">$id\n$newseq1\n";
    print O2 ">$id\n$newseq2\n";
}
close O1;
close O2;
#}
#else{
#    `cp $ARGV[0] $ARGV[1]; cp $ARGV[0] $ARGV[2]`;
#}
