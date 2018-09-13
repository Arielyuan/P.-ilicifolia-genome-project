#!/usr/bin/perl -w
#次脚本用于输出基因组的平均深度，$file是04-1.depth1.pl的输出文件
#脚本路径 输入文件 输出文件
use strict;
my $file = shift;
my $op = "genome_average_depth.txt";
my $evedepth = 0;
my $total = 0;
my $totalbase = 0;
open (F,"<$file") || die ("$!/n");
open (O,">$op") || die ("$!/n");
<F>;
while (my $eve = <F>){
    chomp ($eve);
    my @array = split /\t/,$eve;
    my $depth = $array[0];
    my $basenum = $array[1];
    $totalbase += $array[1];
    $total += $array[0]*$array[1];
}
$evedepth = $total/$totalbase;
print O "$evedepth\n";
close F;
close O;
