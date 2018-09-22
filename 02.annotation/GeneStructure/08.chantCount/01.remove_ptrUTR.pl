#!/usr/bin/perl -w 
use strict;
use Bio::SeqIO;

my $gff = "Ptrichocarpa_filtered.gff3";
my $filtered_file = "ptr.filtered.gff";

open (F,"<$gff") or die ("$!\n");
open (O,">$filtered_file") or die ("$!\n");

my %ptr;
while (my $eve = <F>){
    next if ($eve =~ /^#/);
    next if ($eve =~ /UTR/);
    my $id;
    chomp ($eve);
    my @a = split /\s+/,$eve;
#mrna:ID=Potri.001G000100.1.v3.0;
#cds:ID=Potri.001G000100.1.v3.0.CDS.1;
    my $type = $a[2];
    if ($type eq "CDS"){
	$a[8] =~ /^([^=]+)=([^;]+)\.CDS\.(\d+);/;
	$id = $2;
	$ptr{$id}{cds} .= $eve."\n";
	my $start = $a[3];
	my $end = $a[4];
	push @{$ptr{$id}{start_end}},$start,$end;
    }elsif ($type eq "mRNA"){
	$a[8] =~ /^([^=]+)=([^;]+);/;
	$id = $2;
	$ptr{$id}{mrna} = $eve;
    }
}

foreach my $gene (sort keys %ptr){
    my @new_array = sort {$a<=>$b} @{$ptr{$gene}{start_end}};
    my $new_mrna_start = $new_array[0];
    my $new_mrna_end = $new_array[-1];
    my @array = split/\s+/,$ptr{$gene}{mrna};
    $array[3] = $new_mrna_start;
    $array[4] = $new_mrna_end;
    my $new_mrna = join "\t",@array;
    print O "$new_mrna\n";
    print O "$ptr{$gene}{cds}";
}
close F;
close O;
