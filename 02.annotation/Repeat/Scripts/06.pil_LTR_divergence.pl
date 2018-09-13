#!/usr/bin/perl -w
#统计不同软件跑出来的重复的种类
#脚本的路径 输出文件！！ 输入文件（可以是一个，也可以是很多个gff文件）
use strict;
my $op = shift;
my @file = @ARGV;
my $genomesize = 443685059;
my $opname;
my $class;
my $percdiv;
my $percentage;
open (O,">$op") or die "$!\n";
for (my $j=0;$j<@file;$j++){
    my %hash;
    my $gff_file = $file[$j];
    #文件名是002.op_trf_rank_gff
    if ($gff_file =~ /002.op_([a-z]+)_rank_gff/){
        $opname = $1;
    }else{
        $opname = "result";
    }
    print O "$opname:\n";
    print O "Type\tDivergence(%)\tRepeat Size(bp)\t%ofGenome\t\n";
    open (F,"<$gff_file") or die "$!\n";
    while (my $eve = <F>){
        my @infor = split (/\t/,$eve);
        my $scaffold_name = $infor[0];
        my $start = $infor[3];
        my $end = $infor[4];
        my $infor = $infor[8];
        my @array = split (/;/,$infor);
        #LTR 的两个家族
        #Class=LTR/Gypsy
        if ($array[2]=~/Class=(LTR\/Gypsy)/){
            $class = $1;
            if($array[3]=~/PercDiv=([0-9]+)\.[0-9]+/){
		$percdiv = $1;
            }else{
                print "$array[3]\n";
            }
        }
        elsif($array[2]=~/Class=(LTR\/Copia)/){
            $class = $1;
            if($array[3]=~/PercDiv=([0-9]+)\.[0-9]+/){
		$percdiv = $1;
            }else{
                print "$array[3]\n";
            }
        }
        #提取分歧度PercDiv=11.8
        if($array[3]=~/([0-9]+)\.[0-9]/){
            $percdiv = $1;
        }
        $hash{$class}{$percdiv}+=$end-$start+1;
    }
    foreach my $class(sort keys %hash){
        foreach my $percdiv (sort { $a <=> $b} keys %{$hash{$class}}){
            my $sum = $hash{$class}{$percdiv};
            my $percentage = $sum/$genomesize*100;
            print O "$class\t$percdiv\t$sum\t$percentage\t\n";
        }
    }
}




