#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

my $blat_out_tab = shift;
my $output = shift;
my $total_prp = 40742;

open (F,"<$blat_out") or die ("$!\n");
open (O,">$output") or die ("$!\n");


while (my $eve = <F>){
    chomp ($eve);
    next if ($eve =~/^#/);
    my @a = split/\s+/,$eve;
    my $query_name = $a[0];
    my $start = $a[6];  #$a[6]存放的是query的起始位置
    my $end = $a[7];  #$a[7]存放的是query的终止位置
    if($query_name ne $last_query_name && $last_query_name ne "Hello"){
        my $length = scalar (keys %total_blast_tmp);
        $total_blast{$last_query_name} = $length;
        %total_blast_tmp = ();
    }
    $last_query_name = $query_name;
    for (my $i=$start;$i<=$end;$i++){
        $total_blast_tmp{$i}++;
    }
}
my $length = scalar (keys %total_blast_tmp);
$total_blast{$last_query_name} = $length;

my %count;
my @i = (0.99,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5);
foreach my $query_name(sort keys %query){
    if (exists $total_blast{$query_name}){
	foreach my $i (@i){
	    if ($total_blast{$query_name}/$query{$query_name} >= 1*$i ){
		$count{$i}++;
	    }
	}
    }
}

print O "total_num\tlevel\tnum\tpercent\t\n";
foreach my $i (@i){
    if(!exists $count{$i}){
	$count{$i} = 0;
    }
    my $percent = $count{$i}/$query_num;
    print O "$query_num\t$i\t$count{$i}\t$percent\t\n";
}
close F;
close O;
