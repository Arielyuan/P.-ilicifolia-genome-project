## filter the reads whitch length less than 200bp (N was exclude)

```
#! /usr/bin/perl -w
#此脚本用于基因组gap close后再过滤，去掉不包括N的200bp及以下的序列,修改第8行$filter_length可以改变过滤碱基数的大小
#脚本路径 输入文件 输出文件
use strict;
use Bio::SeqIO;
my $file=shift;
my $op=shift;
my $filter_length = 200;
open (O,">$op")||die("$!\n");
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    my $N=($seq=~tr/[N|n]//);
    my $scaffold_length=length $seq;
    my $effective_scaffold_length=$scaffold_length-$N;
    if($effective_scaffold_length>$filter_length){
    print O ">$id\n$seq\n";
    }
}
close O;
```
