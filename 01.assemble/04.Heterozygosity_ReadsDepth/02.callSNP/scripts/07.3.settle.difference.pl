#!/usr/bin/perl -w
use strict;
my @ip = glob "07.internal.difference.out/*.out";
my $op = "08.final.difference.count";
open (O,">$op") or die ("$!\n");
my %hash;
foreach my $ip (@ip){
    open (I,"<$ip") or die ("$!\n");
    while (my $eve = <I>){
	chomp ($eve);
	my @a = split/\s+/,$eve;
	my $chr = $a[0];
	my $company = $a[1];
	my $eff_num = $a[2];
	my $diff_num = $a[3];
	$hash{$company}{eff_num} += $eff_num;
	$hash{$company}{diff} += $diff_num;
    }
    close I;
}

foreach my $company (sort keys %hash){
    my $per = $hash{$company}{diff}/$hash{$company}{eff_num};
    print O "$company\t$hash{$company}{eff_num}\t$hash{$company}{diff}\t$per\n";
}

close O;
