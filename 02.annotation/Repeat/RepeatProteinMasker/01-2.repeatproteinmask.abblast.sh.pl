#!/usr/bin/perl -w
#此脚本用来生成运行RepeatProteinMask软件的.sh文件
use strict;

my $path="/share/work/user124/software/03.genome_annotation/01.repeat/repeatMasker_abblast/repeatMasker/RepeatMasker/RepeatProteinMask";#修改为你的软件路径
open (O,">$0.sh");
my $filenum=2500;#可修改为文件实际的个数
for(my $i=1;$i<=$filenum;$i++){
    my $fastapath="scaffold100/".$i."\/".$i.".fa";#fasta序列路径
    print O "$path -pvalue 0.0001 -engine abblast $fastapath\n";
}
close O;
