#!/usr/bin/perl -w 
use strict;
my $ip = "01.interpro.blast.out";
my $op = "03.interpro.count.txt";
open (F,"<$ip") or die ("$!\n");
open (O,">$op") or die ("$!\n");

my $total_num = 33684;
my %hash;
while (my $eve = <F>){
    chomp ($eve);
#    next if ($eve =~ /^#/);
    if ($eve =~ /^\d/){
	my @a = split/\t/,$eve;
	my $match_pro = $a[0];
	$hash{$match_pro}++;
    }
}

my $match_num = scalar (keys %hash);
foreach my $pro (sort keys %hash){
    print "$pro\n";
}
my $per = $match_num/$total_num;

print O "match_num\tpercent\t\n";
print O "$match_num\t$per\t\n";

close F;
close O;
