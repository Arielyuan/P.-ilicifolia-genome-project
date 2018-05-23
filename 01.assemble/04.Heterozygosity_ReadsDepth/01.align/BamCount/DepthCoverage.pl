#!/usr/bin/perl -w
use strict;
my $ip_list = "01.bam.list";
my $op = $0.".count";
my $dict = "/share/work/user124/huyang_sex/PeuGenome.dict";

open (D,"<$dict") or die ("$!\n");
<D>;
my $total_length;
while (my $eve = <D>){
    chomp($eve);
    my @a = split/\s+/,$eve;
    $a[2] =~ /LN:(\d+)/;
    my $scaffold_length = $1;
    $total_length += $scaffold_length;
}
close D;
open (I,"<$ip_list") or die ("$!\n");
open (O,">$op") or die ("$!\n");  
print O "id\ttotal_depth\tefficient_num\ttotal_length\n";
while (my $eve = <I>){
    chomp ($eve);
    $eve =~ /03.gatk\/(.+).realn.bam/;
    my $prefix = $1;
    open (F,"/home/share/user/user101/software/samtools/samtools/samtools depth $eve |");
    my $total_depth;
    my $efficient_num;
    open (F,"<$ip") or die ("$!\n");
    $ip =~ /02.op_depth\/(.+).depth/;
    my $prefix = $1;
    while (my $eve = <F>){
        chomp ($eve);
        my @a = split/\s+/,$eve;
        my $depth = $a[2];
        $total_depth += $depth;
        if ($depth > 0){
            $efficient_num++;
        }
    }
    close F;
    print O "$prefix\t$total_depth\t$efficient_num\t$total_length\t\n";
}

close I;
close O;

