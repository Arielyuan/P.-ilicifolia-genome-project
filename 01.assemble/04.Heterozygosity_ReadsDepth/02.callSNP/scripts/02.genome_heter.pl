#!/usr/bin/perl -w
#次脚本用于计算整个基因组的杂合度，需要用到06.SNPcount_filter.pl中第一个输出文件
#脚本路径 输入文件 输出文件
use strict;
my $file = shift;
my $op = shift;
my $total_atgc = 0;
my $total_snp = 0;
my $heter = 0;
open (F,"<$file") || die ("$!/n");
open (O,">$op") || die ("$!/n");
<F>;
while (my $eve = <F>){
    chomp ($eve);
    my @array = split /\t/,$eve;
    $total_atgc += $array[2];
    $total_snp += $array[3];
}
$heter = $total_snp/$total_atgc;
print O "Heterozygosity of the genome is $heter\n";
close F;
close O;
