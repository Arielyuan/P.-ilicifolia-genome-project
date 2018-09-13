#!/usr/bin/perl -w    #将相同的scaffoldname下的重复序列输出到一个文件
use strict;           #脚本的路径 总的gff文件 输出文件
my $file = shift;
my %hash;
open (F,"<$file") || die ("$!\n");
while(my $eve=<F>){
    chomp $eve;
    my @infor = (split/\t/,$eve);
    my $scaffold_name = $infor[0];
    push (@{$hash{$scaffold_name}},$eve);
}
foreach my $scaffold_name(sort keys %hash){
    `mkdir $scaffold_name`;
    my $gff_file = $scaffold_name ."/".$scaffold_name.".gff";
    open (A,">>$gff_file") || die "!/n";
    my @total_infor = @{$hash{$scaffold_name}};
    my $x = join "\n",@total_infor;
    print A "$x\n";
    close A;
}

