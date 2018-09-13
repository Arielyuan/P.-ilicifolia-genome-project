#!/usr/bin/perl -w
#按照基因组fasta中scaffold的顺序将第一步处理过的文件合并到一起
#脚本的路径 基因组fasta文件 第一步排序后的文件 输出的文件
use strict;
use Bio::SeqIO;
my $genome_file = shift;
my @scaffold_name;
open (G,"<$genome_file") || die "!/n";
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    push(@scaffold_name,$id);
}
close G;

#将没有排序的gff输入判断,将每一行存入哈希中
my $messy_gff = shift;
my $op = shift;
my %hash;
open (M,"<$messy_gff") || die "!\n";
open (O,">$op") || die "!\n";
my $rank=1;
my @rank;
while(my $eve = <M>){
    chomp $eve;
    my @infor = split(/\t/, $eve);
    $hash{$infor[0]}{$rank}=$eve;
    push (@rank,$rank);
    $rank++;
}

#对于每一个基因组里的scaffold，根据基因组的顺序编一个ID
foreach my $scaffold_name(@scaffold_name){
    if (exists $hash{$scaffold_name}){
        foreach my $rank(sort {$a <=> $b} keys %{$hash{$scaffold_name}}){
	    my $eve = $hash{$scaffold_name}{$rank};
	    my @eve = split/\t/,$eve;
	    print O "$eve[0]\t$eve[1]\t$eve[2]\t$eve[3]\t$eve[4]\t$eve[5]\t$eve[6]\t$eve[7]\t$eve[8]\t\n";
        }
    }
}
close M;
close O;
