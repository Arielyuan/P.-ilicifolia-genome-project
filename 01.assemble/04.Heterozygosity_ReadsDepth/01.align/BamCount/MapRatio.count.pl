#!/usr/bin/perl -w
use strict;
my $ip_list = "01.bam.list";
my $op = $0.".count";
open (I,"<$ip_list") or die ("$!\n");
open (O,">$op") or die ("$!\n");  
open (O,">$op") or die ("$!\n");
print O "id\ttotal_reads\tmapped_reads\t$MapRatio\n";

while (my $eve = <I>){
    chomp ($eve);
    $eve =~ /03.gatk\/(.+).realn.bam/;
    my $prefix = $1;
    open (F,"/home/share/user/user101/software/samtools/samtools/samtools flagstat $eve |");
    my $first = <F>;
    chomp ($first);
    my @line1 = (split/\s+/,$first);
    my $total = $line1[0];
    <F>;
    <F>;
    <F>;
    my $fifth = <F>;
    chomp($fifth);
    my @line5 = (split/\s+/,$fifth);
    my $mapped = $line5[0];
    my $ratio = $mapped / $total;
    print O "$id\t$total\t$mapped\t$ratio\n";
    close F;
}


close O;
close I;
