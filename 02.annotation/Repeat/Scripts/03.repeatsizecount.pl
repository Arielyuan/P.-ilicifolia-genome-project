#!/usr/bin/perl -w
#统计每一个软件跑出来的重复序列占得比例，如果输入总的文件统计出来的是全部的比例（total）
#脚本的路径 输出文件！！ 输入文件（可以是一个，也可以同时输几个）
use strict;
my $op = shift;
my @file = @ARGV;
my $genomesize = 443685059;
my $opname;
my $percentage;
open (O,">$op") or die "$!\n";
print O "Type\tRepeat Size(bp)\t%ofGenome\t\n";
for (my $j=0;$j<@file;$j++){
    my $sum = 0;
    my %hash;
    my $gff_file = $file[$j];
    #文件名是002.op_trf_rank_gff
    if ($gff_file =~ /002.op_([a-z]+)_rank_gff/){
        $opname = $1;
    }
    print O "$opname\t";
    open (F,"<$gff_file") or die "$!\n";

    while (my $eve = <F>){
        my @infor = split (/\t/,$eve);
        my $scaffold_name = $infor[0];
        my $start = $infor[3];
        my $end = $infor[4];
        for (my $i=$start;$i<=$end;$i++){
            $hash{$scaffold_name}{$i}++;
        }
    }

    foreach my $scaffold_name(keys %hash){
        my @k = keys %{$hash{$scaffold_name}};
        my $evenum = scalar @k;
        $sum += $evenum;
    }
    print O "$sum\t";
    $percentage = $sum/$genomesize*100;
    print O "$percentage\t\n";
}
