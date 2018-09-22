#!/usr/bin/perl -w
use strict;
my $sqltable_file = shift;
my $opcount = shift;
open (F,"<$sqltable_file" ) or die ("$!\n");
open (O,">$opcount") or die ("$!\n");

my %hash;
while (my $eve = <F>){
    my @a = split/\s+/,$eve;
    $hash{$a[0]}++;
}

my $vs1_num = 0;
foreach my $id (sort keys %hash){
    if ($hash{$id} == 2){
	$vs1_num++;
    }else{
	next;
    }
}

print O "1vs1_num is $vs1_num\n";
close F;
close O;
