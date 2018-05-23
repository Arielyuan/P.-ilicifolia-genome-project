#!/usr/bin/perl -w
use strict;
my $ip = "06.heter.count";
#spe     ind     heter_num       total_num       per
open (I,"<$ip") or die ("$!\n");
my $op = "06-2.total.heter.ave_sd.count";
open (O ,">$op") or die ("$!\n");
my %hash; #物种
my %ind_hash; #个体
my %num;
<I>;
<I>;
while (my $eve = <I>){
    chomp ($eve);
    my @a = split /\s+/,$eve;
    my $ind = $a[1];
    my $spe = $a[0];
    my $per = $a[4];
    $ind_hash{$spe}{$ind} = $per;
    $hash{$spe} += $per;
    $num{$spe}++;
}

print O "spe\tmean_heter\tsd_heter\n";
foreach my $spe (sort keys %hash){
    my $ave = $hash{$spe}/$num{$spe};
    my $tmp = 0;
    foreach my $ind (sort keys %{$ind_hash{$spe}}){
	$tmp += ($ind_hash{$spe}{$ind} - $ave)*($ind_hash{$spe}{$ind} - $ave);
    }
    my $mse = $tmp /$num{$spe};
    my $sd = sqrt($mse);
    print O "$spe\t$ave\t$sd\n";
}

close O;
