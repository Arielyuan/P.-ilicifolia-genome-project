#!/usr/bin/perl -w
use strict;
my $sqltable_file = shift;
my $opcount = shift;
open (F,"<$sqltable_file" ) or die ("$!\n");
open (O,">$opcount") or die ("$!\n");

my %hash;
while (my $eve = <F>){
    my @a = split/\s+/,$eve;
    my $no = $a[0];
    my $species = $a[2];
    $hash{$no}{$species}++;
}

my %count;
foreach my $no (sort keys %hash){
    my $value = $hash{$no}{"pilpredict.pep"}."vs".$hash{$no}{"ptr.pep"};
    if($hash{$no}{"pilpredict.pep"}+$hash{$no}{"ptr.pep"}>50){
	print "$no\n";
    }
    $count{$value}++;
}

print O "pil/ptr:\n";
print O "value\tnum\t\n";
foreach my $value (sort keys %count){
    print O "$value\t$count{$value}\t\n";
}
close F;
close O;
