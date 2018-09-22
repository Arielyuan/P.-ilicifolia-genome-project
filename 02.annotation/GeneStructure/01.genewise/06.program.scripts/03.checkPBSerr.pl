#!/usr/bin/perl -w
#此脚本用来检查提交任务后产生的err文件是否为空，如果不是空则输出此文件是啥！
use strict;
my $path="/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/04.runGenwise/04-2.cpa.pbs";#请将此路径修改为err文件的路径
my @file=glob($path."/*.err");
foreach my $file(@file){
    if(-z $file){}else{print"$file\n";}
}
