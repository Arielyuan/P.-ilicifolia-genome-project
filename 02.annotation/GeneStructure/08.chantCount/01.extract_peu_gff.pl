#!/usr/bin/perl -w 
use strict;
use Bio::SeqIO;

my $gff = "v2.Populus_euphratica.gff";
my $filtered_file = "peu.filtered.gff";

open (F,"<$gff") or die ("$!\n");
open (O,">$filtered_file") or die ("$!\n");

my %peu;
while (my $eve = <F>){
    next if ($eve =~ /^#/);
    next if ($eve =~ /UTR/);
    my $id;
    chomp ($eve);
    my @a = split /\s+/,$eve;
#mrna:ID=CCG000001.1;source_id=P.eup_GLEAN_10033685;
#cds:Parent=CCG000003.1;
    my $type = $a[2];
    $a[8] =~ /^([^=]+)=([^;]+);/;
    $id = $2;
    if ($type eq "CDS"){
	$peu{$id}{cds} .= $eve."\n";
	my $start = $a[3];
	my $end = $a[4];
	push @{$peu{$id}{start_end}},$start,$end;
    }elsif ($type eq "mRNA"){
	$peu{$id}{mrna} = $eve;
#	print "$peu{$id}{mrna}\n";
    }
}

foreach my $gene (sort keys %peu){
    my @new_array = sort {$a<=>$b} @{$peu{$gene}{start_end}};
    my $new_mrna_start = $new_array[0];
    my $new_mrna_end = $new_array[-1];
    # print "$peu{$gene}{mrna}\n";
    my @array = split/\s+/,$peu{$gene}{mrna};
    $array[3] = $new_mrna_start;
    $array[4] = $new_mrna_end;
    my $new_mrna = join "\t",@array;
    print O "$new_mrna\n";
    print O "$peu{$gene}{cds}";
}
close F;
close O;
