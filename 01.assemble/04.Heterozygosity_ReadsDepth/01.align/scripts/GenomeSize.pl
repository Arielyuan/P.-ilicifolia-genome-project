#!/usr/bin/perl -w
#此脚本用于从dict文件中读取基因组的大小
#脚本路径 输入文件（samtools输出的dict文件） 输出文件
use strict;
my $dictfile = shift;
my $op = shift;
open (F,"<$dictfile") or die ("$!\n");
open (O,">$op") or die ("$!\n");
my $genomesize = 0;
<F>;
while (my $eve = <F>){
    chomp ($eve);
    my @infor = split/\s+/,$eve;
    my $evelength = substr($infor[2],3);
    $genomesize += $evelength;
}
print O "GenomeSize:$genomesize\n";
