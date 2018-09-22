#!/usr/bin/perl -w
use strict;
#此脚本根据end的位置将基因分成一个个cluster，并筛出一个分值最高的基因
my $standard_gff = shift;
my $op_gff = shift;
my %hash;
open (F,"<$standard_gff") or die ("$!\n");
open (O,">$op_gff") or die ("$!\n");
while (my $eve = <F>){
    my $gene_name;
    chomp ($eve);
    next if($eve=~/^$/);
    my @infor = split/\s+/,$eve;
    my $line_eight = $infor[8];
    if ($line_eight =~ /(\w+)\=(.+)/){
        $gene_name = $2;
    }
    my $scaffold_name = $infor[0]."_".$infor[6];
    my $type = $infor[2];
    $hash{$scaffold_name}{$gene_name}{gff}.= $eve."\n";
    if ($type eq "mRNA"){
	my $start = $infor[3];
	my $end = $infor[4];
	my $score = $infor[5];
	$hash{$scaffold_name}{$gene_name}{score} = $score;
	$hash{$scaffold_name}{$gene_name}{end} = $end;
	$hash{$scaffold_name}{$gene_name}{start} = $start;
    }
}
close F;

#open(E,"> debug.txt");
foreach my $scaffold (sort keys %hash){
    my $last_start = -1;
    my $last_end = -1;
    my $max_score = 0;
    my $max_gff;
    # my $start;
    # my $end;
    foreach my $gene (sort {$hash{$scaffold}{$a}{end} <=> $hash{$scaffold}{$b}{end}} keys %{$hash{$scaffold}}){
	my $start = $hash{$scaffold}{$gene}{start};
	my $end = $hash{$scaffold}{$gene}{end};
	my $score=$hash{$scaffold}{$gene}{score};
	my $gff=$hash{$scaffold}{$gene}{gff};
	# print E "$gff";
	if ($last_end == -1){
	    $last_end = $end;
	    $last_start = $start;
	    $max_gff = $gff;
	    $max_score = $score;
	}
	elsif ($start < $last_end){
	    # print E "$gff";
	    if ($score>$max_score){
		$max_score = $score;
		$max_gff = $gff;
	    }
	}
	else{
	    if ($max_score > 70){
		print O "$max_gff";
	    }
	    # print E "$gff";
	    $last_start = $start;
	    $last_end = $end;
	    $max_gff = $gff;
	    $max_score = $score;
	}
    }
    if ($max_score > 70){
	print O "$max_gff";
    }
}	    
#close E;
