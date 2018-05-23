#!/usr/bin/perl -w
#此脚本用来做全基因组的depth柱状统计图：即把depth分成以10为一个区间，合并大于200的所有碱基数；得到每个深度区间中的碱基数目
#输入文件（需要用到04.depth1.pl跑出来的结果） 输出文件
use strict;
my $file = shift;
my $op = shift;
my $totalbase;
my %hash;
open (F,"<$file") || die ("$!\n");
open (O,">$op") || die ("$!\n");
print O "depth\tbasenum\tpercentage\n";
while (my $eve = <F>){
    my @array = split/\t/,$eve;
    my $depth = $array[0];
    my $basenum = $array[1];
    $totalbase+=$basenum;
    if ($depth<10){
	$hash{0} += $basenum;
    }
    elsif($depth>200){
	$hash{210} += $basenum;
    }
    else{
        $hash{int($depth/10)*10} += $basenum;
    }
}
foreach my $depth (sort {$a<=>$b} keys %hash){
    my $percentage = ($hash{$depth})/$totalbase;
    print O "$depth\t$hash{$depth}\t$percentage\n";
}
