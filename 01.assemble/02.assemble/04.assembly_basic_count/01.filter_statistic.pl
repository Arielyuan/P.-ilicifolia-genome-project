#!/usr/bin/perl -w
#统计原始/过滤数据信息的表格：包括插入片段大小，resds数量，长度，总的数据量，深度等,从第7行修改基因组大小,可通过08.genomesize.pl脚本计算得出
#脚本路径 输入文件（可以为压缩/解压形式，需要paired-end数据，成对输入）如：Populus_ilicifolia.10kbp.1.fq.gz Populus_ilicifolia.10kbp.2.fq.gz Populus_ilicifolia.5kbp.1.fq.gz Populus_ilicifolia.5kbp.2.fq.gz ……
use strict;
my $op="01.reads.quality.count";
open (O,">$op")or die ("$!\n");
my @file=@ARGV;
my $genomesize = 399970306;
print O "Insert Size(bp)\tReads Number\tReads Length(bp)\tTotal Data(bp)\tDepth(X)\t\n";
for (my $j=0;$j<@file;$j=$j+2){
    my $input1=$file[$j];
    my $input2=$file[$j+1];
    if($input1=~/gz$/){
        open (I1,"zcat $input1 |")||die("$!\n");
        open (I2,"zcat $input2 |")||die("$!\n");
        #scriptfilter.500bp.1.filter.cor.fq.gz
        print "$input1\n";
        if($input1=~/[^\d]+(\d+)/){
            print O "$1\t";
        }
    }else{
        open (I1,"< $input1")||die("$!\n");
        open (I2,"< $input2")||die("$!\n");
        print "$input1\n";
        if($input1=~/[^\d]+(\d+)/){
            print O "$1\t";
        }
    }
    my $reads1=0;
    my $reads2=0;
    my $num1=0;
    my $num2=0;
    while (<I1>){
	my $l1=$_;
	chomp(my $l2=<I1>);
	my $each_line_reads1=length($l2);
	$reads1+=$each_line_reads1;
	$num1++;
	<I1>;
	<I1>;
    }
    close I1;
    while (<I2>){
	my $l3=$_;
	chomp(my $l4=<I2>);
	my $each_line_reads2=length($l4);
	$reads2+=$each_line_reads2;
	$num2++;
	<I2>;
	<I2>;
    }
    close I2;
    my $readsnumber=$num1+$num2;
    my $totaldata=$reads1+$reads2;
    my $readslength=$totaldata/$readsnumber;
    my $depth=$totaldata/$genomesize;
    print O "$readsnumber\t$readslength\t$totaldata\t$depth\n";
}
close O;
