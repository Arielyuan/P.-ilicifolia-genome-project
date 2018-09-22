#!/usr/bin/perl -w
use strict;
my $op_count = shift;
my @standard_gff = @ARGV;
open (O,">$op_count") or die ("$!\n");
print O "species\tappear_times\tbase_num\t\n";
#05.rco.standerd.gff
for (my $j=0;$j<@standard_gff;$j++){
    my %hash;
    my $species;
    my $total_cds = 0;
    my $nonoverlap = 0;
    open (F,"<$standard_gff[$j]") or die ("$!\n");
    if($standard_gff[$j] =~ /(\d+)\.(\w+)\.*/){
        $species = $2;
    }
    while (my $eve = <F>){
        my @infor = split (/\t/,$eve);
	my $strand = $infor[6];
        my $scaffold_name = $infor[0]."_".$infor[6];
        my $start = $infor[3];
        my $end = $infor[4];
        my $type = $infor[2];
        if ($type eq "CDS"){
            $total_cds+=($infor[4]-$infor[3]);
            for (my $i=$start;$i<=$end;$i++){
                $hash{$scaffold_name}{$i}++;
            }
        }
    }
    my %sta;
    foreach my $scaffold_name(keys %hash){
	foreach my $pos (keys %{$hash{$scaffold_name}}){
	    my $count = $hash{$scaffold_name}{$pos};
	    $sta{$count}++;
	}
    }
    foreach my $count (sort {$b <=> $a} keys %sta){
	print O "$species\t$count\t$sta{$count}\t\n";
    }
}
