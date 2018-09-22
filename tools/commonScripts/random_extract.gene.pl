#! /usr/bin/perl -w
use strict;
use List::Util;
my $gff_file = shift;
my $op = shift;
my $num = 3000;
open (F,"<$gff_file") || die "Cannot read $gff_file!\n";
open (O,">$op") || die "Cannot create $op!\n";
my @gff_array;
my %hash;
while (my $eve = <F>){
    chomp ($eve);
    my @infor = split/\s+/,$eve;
    my $scaffold_name = $infor[0];
    $infor[8]=~/=([^;]+);/;
    my $gene_name = $1;
    $hash{$scaffold_name}{$gene_name} .= $eve."\n";
}

foreach my $scaffold_name(sort keys %hash){
    foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	push (@gff_array,$hash{$scaffold_name}{$gene_name});
    }
}

@gff_array=List::Util::shuffle @gff_array;

foreach my $gene(@gff_array){
    if ($num>0){
	print O "$gene";
    }
    $num--;
}
