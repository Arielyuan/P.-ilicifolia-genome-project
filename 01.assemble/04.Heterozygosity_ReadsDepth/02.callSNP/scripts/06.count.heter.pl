#!/usr/bin/perl -w
use strict;
my $vcf = shift;
#$vcf =~ /\/scaffold(.+).allsite.vcf.gz/;
#my $id =$1;
#my $op_dir = "03.indtotal.heter.count";
#`mkdir $op_dir` if (!-e $op_dir);
#my $op = $op_dir."/".$id.".out";
my $op = "06.heter.count";
open (F,"zcat $vcf|") || die ("$!/n");
open (O ,">$op") or die ("$!/n");

my %hash;
my %heter;
while (my $eve = <F>){
    chomp ($eve);
    if($eve =~ /^##/){
        next;
    }elsif($eve =~ /^#/){
	my @a=split(/\s+/,$eve);
	my $length = scalar (@a);
	for (my $i=9;$i<$length;$i++){
	    $hash{$i} = $a[$i];
	    $heter{$i}{heter}=0;
	    $heter{$i}{total}=0;
	}
    }else{
        my @a=split(/\s+/,$eve);
	my $length = scalar (@a);
	for (my $i=9;$i<$length;$i++){
	    if ($a[$i] !~ /\.\/\./){
		$heter{$i}{total}++;
		if (($a[$i] =~ /0\/1/) || ($a[$i] =~ /1\/0/)){
		    $heter{$i}{heter} ++;		    
		}
	    }
	}
    }
}
print O "spe\tind\theter_num\ttotal_num\tper\n";
foreach my $i (sort keys %hash){    
    my $ind = $hash{$i};
    $ind =~ /([^\d]+)\d+/;
    if (!exists $heter{$i}{heter}){
	$heter{$i}{heter}=0;
    }
    next if (!exists $heter{$i}{total});
    next if ($heter{$i}{total} == 0);
    my $spe = $1;
    my $per = $heter{$i}{heter}/$heter{$i}{total};
    print O "$spe\t$ind\t$heter{$i}{heter}\t$heter{$i}{total}\t$per\n";
}
close F;
close O;
