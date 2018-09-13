#!/usr/bin/perl -w
use strict;
my $file = shift;
my $op = shift;
open (F,"<$file") or die "$!\n";
open (O,">$op") or die "$!\n";
my $olds = $/;
$/ = "Sequence: ";
#my $j=0;
#my $l=8;
while (my $eve = <F>){
    my @elements = split (/\n/,$eve);
    for (my $i=7;$i<@elements;$i++){
        if ($elements[$i]=~/^\d/){
            print O "$elements[0]\t";
            my @infor = split (/\s/,$elements[$i]);
#	    $j++;
#	    my $n = length $j;
#	    my $zero = $l - $n;
#	    my $ID = "0" x $zero . $j;
            print O "TRF\tTandemRepeat\t$infor[0]\t$infor[1]\t$infor[8]\t+\t.\tRepeatNum=$infor[3];RepeatSize=$infor[2];MatchPer=$infor[5];DelatePer=$infor[6];Consensus=$infor[13];\n";
        }
    }
}
$/=$olds;
close F;
close O;
