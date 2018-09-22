#!/usr/bin/perl -w 
use strict;
my $ipgff = shift;
my $opgff = shift;
open (I,"<$ipgff") or die ("$!\n");
open (O,">$opgff") or die ("$!\n");
while (my $eve = <I>){
    chomp ($eve);
    my @infor = split /\s+/,$eve;
    next if ($infor[2] eq "mRNA");
    my $neweve = $eve;
    $neweve =~ s/Parent/ID/;
#    Parent=peu-scaffold10012_cov116-2
    print O "$neweve\n";
}
close I;
close O;    
