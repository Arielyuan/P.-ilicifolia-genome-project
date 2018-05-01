#!/usr/bin/perl -w
#此脚本用于soap软件组装基因组时生成config文件，需要输入paired-end文件，文件名为“字母.数字（插入片段大小**bp或**kb）等” 并且需要将第9行$max_rd_len改为自己reads的最大长度
#注意，reads的命名，以fa.gz结尾，短片段的reads如：pil.500bp.1.fq.gz;长片段的reads如：pil.2kbp.1.fq.gz
use strict;

my $max_rd_len=shift;  #my $max_rd_len=126;
my @file=@ARGV;  #reads 的目录
my $op = "04.soapGapClose.config";  #输出文件
open (O,">$op") or die ("$!\n");

if(scalar(@ARGV) == 0){
    die "Usage:\n$0 max_rd_len ReadsDir\n";
}

print O "#maximal read length\nmax_rd_len=$max_rd_len\n[LIB]\n";
for (my $j=0;$j<@file;$j=$j+2){
    my $insertsize;
    my $input1=$file[$j];
    my $input2=$file[$j+1];
    #scriptfilter.500bp.1.filter.cor.fq.gz
    if($input1=~/[^\d]+(\d+)kb/){
        $insertsize = $1 *1000;
    }
    elsif($input1=~/[^\d]+(\d+)bp/){
        $insertsize = $1;
    }
    if ($insertsize<2000){
        print O "avg_ins=$insertsize\nreverse_seq=0\nasm_flags=3\nrank=1\npair_num_cutoff=3\nmap_len=32\nq1=$input1\nq2=$input2\n";
    }
    elsif($insertsize>=2000 && $insertsize<5000){
        print O "avg_ins=$insertsize\nreverse_seq=1\nasm_flags=2\nrank=2\npair_num_cutoff=5\nmap_len=35\nq1=$input1\nq2=$input2\n";
    }
    elsif($insertsize>=5000 && $insertsize<10000){
        print O "avg_ins=$insertsize\nreverse_seq=1\nasm_flags=2\nrank=3\npair_num_cutoff=5\nmap_len=35\nq1=$input1\nq2=$input2\n";
    }
    elsif($insertsize>=10000){
        print O "avg_ins=$insertsize\nreverse_seq=1\nasm_flags=2\nrank=4\npair_num_cutoff=5\nmap_len=35\nq1=$input1\nq2=$input2\n";
    }
}
close O;
