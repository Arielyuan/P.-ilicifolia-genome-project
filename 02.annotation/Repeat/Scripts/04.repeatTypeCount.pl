#!/usr/bin/perl -w
#统计不同软件跑出来的重复的种类
#脚本的路径 输出文件！！ 输入文件（可以是一个，也可以是很多个gff文件）
use strict;
my $op = shift;
my @file = @ARGV;
my $genomesize = 443685059;
my $opname;
my $class;
my $percentage;
open (O,">$op") or die "$!\n";
for (my $j=0;$j<@file;$j++){
    my %hash;
    my $gff_file = $file[$j];
    #文件名是002.op_trf_rank_gff
    if ($gff_file =~ /002.op_([a-z]+)_rank_gff/){
        $opname = $1;
    }
    print O "$opname:\n";
    print O "Type\tRepeat Size(bp)\t%ofGenome\t\n";
    open (F,"<$gff_file") or die "$!\n";
    while (my $eve = <F>){
        my @infor = split (/\t/,$eve);
        my $scaffold_name = $infor[0];
        my $start = $infor[3];
        my $end = $infor[4];
	my $infor = $infor[8];
	my @array = split (/;/,$infor);
	#Class=LTR/Gypsy
	if ($array[2]=~/Class=([a-zA-Z]+\/[a-zA-Z]+)/){
	    $class = $1;
	}
	elsif($array[2]=~/Class=([a-zA-Z]+)/){
	    $class = $1;
	   # $class = "TRF";
	}
	else{print "$array[2]\n"}
	for (my $i=$start;$i<=$end;$i++){
            $hash{$class}{$scaffold_name}{$i}++;
        }
    }
    my @k;
    foreach my $class(sort keys %hash){
	my $sum = 0;
        foreach my $scaffold_name(keys %{$hash{$class}}){
	    @k = keys %{$hash{$class}{$scaffold_name}};
	    my $evenum = scalar @k;
	    $sum += $evenum;
	}
	print O "$class\t$sum\t";
	$percentage = $sum/$genomesize*100;
	print O "$percentage\t\n";
    }
}	    
