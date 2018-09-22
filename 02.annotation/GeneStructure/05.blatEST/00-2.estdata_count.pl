#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

my $blat_output = shift;
my $query = shift;
#my $op = "02-2.pil-ppr.count";
my $op = shift;

open (F,"<$blat_output") or die ("$!\n");
open (O,">$op") or die ("$!\n");

#取出每个querry大小以及每个长度的信息,存在query这个哈希中
my %total_length;
my %query;
my $fa=Bio::SeqIO->new(-file=>$query,-format=>'fasta');
my @i = (0,200,500,1000); 
while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    my $single_length = length($seq);
    $query{$id} = $single_length;
    foreach my $point (@i){
	if ($query{$id} > $point){
	    $total_length{$point} += $query{$id};
	}
    }
}
#读blat的输出文件，提取相关信息
my %hash;
my %total_blast;
while (my $eve = <F>){
    chomp ($eve);
    my @a = split/\s+/,$eve;
    my $query_name = $a[0];
    my $scaffold_name = $a[1];
    my $start = $a[6];
    my $end = $a[7];
    for (my $i=$start;$i<=$end;$i++){
	$total_blast{$query_name}{$i}++;
	$hash{$query_name}{$scaffold_name}{$i}++;
    }
}

foreach my $point (@i){
    my $total_blast;
    my $total_num;
    my $over90num;
    my $over90length;
    my $over50num;
    my $over50length;
    foreach my $query_name(sort keys %query){
	if ($query{$query_name} > $point){
	    $total_num ++;
	    if (exists $total_blast{$query_name}){
		# $total_num ++;
		$total_blast+= scalar (keys %{$total_blast{$query_name}});
	    }
	    if (exists $hash{$query_name}){
		my %query_map_length;
		foreach my $scaffold_name(keys %{$hash{$query_name}}){
		    my $eve_length = scalar( keys %{$hash{$query_name}{$scaffold_name}} );
		    $query_map_length{$scaffold_name}=$eve_length;
		}
		my @length_sorting = sort {$query_map_length{$b}<=>$query_map_length{$a}} keys %query_map_length;
		my $selected_scaffold = $length_sorting[0];
		my $selected_length   = $query_map_length{$selected_scaffold};
		if($selected_length > 0.5* ($query{$query_name})){
		    $over50num ++;
#		    $over50length += $selected_length;
		    if ($selected_length > 0.9* ($query{$query_name})){
			$over90num ++;
#			$over90length += $selected_length;
		    }
		}
	    }
	}
    }    
    print O "Length of unigene\tTotal number\tTotal length\tCovered by assembly(%)\tWith >90% sequence in one scaffold\tWith >50% sequence in one scaffold\t\n";
    print O "$point\t";
    my $total_per = (($total_blast/$total_length{$point})*100);
    my $p90 = ($over90num / $total_num);
    my $p50 = ($over50num / $total_num);
    print O "$total_num\t$total_length{$point}\t$total_per\t$over90num\t$p90\t$over50num\t$p50\t\n";
}
close F;
close O;
