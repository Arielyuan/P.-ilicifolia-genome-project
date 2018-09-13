#!/usr/bin/perl -w    #是将所有软件跑出来的重复序列相同的scaffoldname下的重复序列合并在一起
use strict;           #脚本的路径 四个软件cat到一起的gff文件 输出文件
my $file = shift;
my $op = shift;
my %hash;
open (F,"<$file") || die ("$!\n");
open (O,">$op") || die ("$!\n");
while(my $eve=<F>){
    chomp $eve;
    my @infor = (split/\t/,$eve);
    my $scaffold_name = $infor[0];
    push (@{$hash{$scaffold_name}},$eve);
}
foreach my $scaffold_name(sort keys %hash){
    my @total_infor = @{$hash{$scaffold_name}};
    my $x = join "\n",@total_infor;
    print O "$x\n";
}
