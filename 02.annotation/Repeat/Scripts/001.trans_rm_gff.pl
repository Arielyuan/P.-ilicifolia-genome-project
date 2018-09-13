#!/usr/bin/perl -w
use strict;
my $file=shift;
my $op=shift;
open (F,"<$file") || die ("$!\n");
open (O,">$op") || die ("$!\n");
#my $j=0;
#my $l=8;
<F>;
<F>;
<F>;
my $nosimple;
while (my $eve=<F>){
    chomp($eve);
    my $neweve=$eve;
    $neweve=~s/^\s+//;
    my @array = split (/\s+/,$neweve);
#    $j++;
#    my $n = length $j;
#    my $zero = $l - $n;
#    my $ID = "0" x $zero . $j;
    if ($array[10] ne "Simple_repeat"){
	if ($array[8] eq 'C'){
	    $array[8] = "-";
	}
	print O "$array[4]\tRepeatMasker\tTransposon\t$array[5]\t$array[6]\t$array[0]\t$array[8]\t.\t";
	if ($array[11]=~/^\d/){
	    print O "Target=lcl|$array[9] $array[11] $array[12];Class=$array[10];PercDiv=$array[1];PercDel=$array[2];PercIns=$array[3];\n";
	}else{
	    print O "Target=lcl|$array[9] $array[13] $array[12];Class=$array[10];PercDiv=$array[1];PercDel=$array[2];PercIns=$array[3];\n";
	}
    }
}

close F;
close O;
