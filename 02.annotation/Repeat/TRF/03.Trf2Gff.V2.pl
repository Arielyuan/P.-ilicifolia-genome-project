#!/usr/bin/perl -w
#将trf的.out文件转换为gff文件
#input为trf跑出来的.out文件，output为转换后的gff文件名
use strict;
my $input=shift;
my $output=shift;
open (I,"<$input");
open (O,">$output");
LINE:while (<I>){
    chomp;    
    my $l1=$_;
    if ($l1=~/^Sequence:\s(\S+)/){
        my $seq_ID=$1;
        while (<I>){
            chomp;
            my $l2=$_;
            if ($l2=~/^([0-9]+\s)/){
                $number++;
                my @repeats=split/\s+/,$l2;
                my $len=length($number);
                my $i=6-$len;
                my $zero="0"x$i;
                my $ID="$zero$number";
                print O "$seq_ID\ttrf\tRepeat\t$repeats[0]\t$repeats[1]\t$repeats[7]\t+\t.\tID=TR$ID;RepeatTimes=$repeats[3];RepeatSize=$repeats[2];PercentMatch=$repeats[5];PercentDelta=$repeats[6];A=$repeats[8];C=$repeats[9];G=$repeats[10];T=$repeats[11];Entropy=$repeats[12];Repeatunit=$repeats[13]\n";
            }elsif($l2=~/Sequence:\s(\S+)/){
                redo LINE;
            }
        }
    }
}
close I;
close O;
