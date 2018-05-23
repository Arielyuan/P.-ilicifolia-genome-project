#!/usr/bin/perl -w 
use strict;
my $vcf = shift;
my $op = shift;

open (I,"zcat $vcf |") or die ("$!\n");
open (O,">$op") or die ("$!\n");
my $length;
my %hash;
my %count;
my $eff_site_num=0;
while (my $eve = <I>){
    chomp ($eve);
    next if ($eve =~ /^##/);
    if($eve =~ /^#/){
        my @a=split(/\s+/,$eve);
        $length = scalar (@a);
        for (my $i=9;$i<$length;$i++){
            $hash{$i} = $a[$i];
        }
    }else{
	my @a=split(/\s+/,$eve);
	my $scaffold = $a[0];
	for (my $i=9;$i<$length-1;$i++){
	    for (my $j=$i+1;$j<$length;$j++){
		if (($a[$i] !~ /\.\/\./) && ($a[$j] !~ /\.\/\./)){
		    $count{$scaffold}{$hash{$i}}{$hash{$j}}{total}++;
		    if ($a[$i] ne $a[$j]){
			$a[$i] =~ /(\d)\/(\d)/;
			my $num1 = $1;
			my $num2 = $2;
			$a[$j] =~ /(\d)\/(\d)/;
			my $num3 = $1;
			my $num4 = $2;
			if ($num1 ne $num3){
			    $count{$scaffold}{$hash{$i}}{$hash{$j}}{diff}+= 0.5;
			}
			if ($num2 ne $num4){
			    $count{$scaffold}{$hash{$i}}{$hash{$j}}{diff}+= 0.5;
			}
		    }
		}
	    }
	}
    }
}
foreach my $scaffold (sort keys %count){
    foreach my $spe1 (sort keys %{$count{$scaffold}}){
	foreach my $spe2 (sort keys %{$count{$scaffold}{$spe1}}){
	    if (!exists $count{$scaffold}{$spe1}{$spe2}{total}){
		$count{$scaffold}{$spe1}{$spe2}{total}=0;
	    }
	    if (! exists $count{$scaffold}{$spe1}{$spe2}{diff}){
		$count{$scaffold}{$spe1}{$spe2}{diff}=0;
	    }
	    print O "$scaffold\t$spe1-$spe2\t$count{$scaffold}{$spe1}{$spe2}{total}\t$count{$scaffold}{$spe1}{$spe2}{diff}\n";
	}
    }
}

close O;
