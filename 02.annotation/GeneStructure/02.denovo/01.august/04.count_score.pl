#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_count = shift;
open (F,"<$gff_file") or die ("$!\n");
open (O,">$op_count") or die ("$!\n");

my %hash;
my $totalnum;
while (my $eve = <F>){
    chomp ($eve);
    my @a = split /\s+/,$eve;
    my $type = $a[2];
    my $score = $a[5];
    next if $type eq "CDS";
    my $section = (int ($score*10))/10;
    $totalnum++;
    $hash{$section}++;
}
close F;

foreach my $section (sort {$a <=> $b} keys %hash){
    my $percent = $hash{$section} / $totalnum;
    print O "$section\t$hash{$section}\t$percent\t\n"
}
close O;
