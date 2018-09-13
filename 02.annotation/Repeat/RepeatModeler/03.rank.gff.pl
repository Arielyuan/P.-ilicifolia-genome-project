#!/usr/bin/perl -w
#得到基因组fasta中scaffold的顺序
use strict;
use Bio::SeqIO;
my $genome_file = shift;
my @scaffold_name;
open (G,"<$genome_file") || die "Cannot read $genome_file!\n";
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
open (M,"<$messy_gff") || die "Cannot open $messy_gff!\n";
open (O,">$op") || die "Cannot create $op!\n";
my $rank=1;
my @rank;
while(my $eve = <M>){
    chomp($eve);
    my @infor = split(/\t/, $eve);
    $hash{$infor[0]}{$rank}=$eve;
    push (@rank,$rank);
    $rank++;
}

#对于每一个基因组里的scaffold，根据基因组的顺序编一个ID
my $j=0;
my $l=8;
foreach my $scaffold_name(@scaffold_name){
    if (exists $hash{$scaffold_name}){
        foreach my $rank(sort {$a <=> $b} keys %{$hash{$scaffold_name}}){
            $j++;
            my $eve = $hash{$scaffold_name}{$rank};
            my @eve = split/\t/,$eve;#第八个元素就是ID要插入的位置
            my @supple = split/;/,$eve[8];#把第八个元素即附加信息按照“；”存入数组中
            my $n = length $j;
            my $zero = $l - $n;
            my $ID = "ID=DN".("0" x $zero). $j;
            unshift @supple, $ID;
            my $new = join ";",@supple;
            print O "$eve[0]\t$eve[1]\t$eve[2]\t$eve[3]\t$eve[4]\t$eve[5]\t$eve[6]\t$eve[7]\t$new\n";
        }
    }
}
close M;
close O;
