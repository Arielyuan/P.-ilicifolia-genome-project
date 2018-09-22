#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_standard_gff = shift;
open (F,"<$gff_file") || die ("!\n");
open (O,">$op_standard_gff") || die ("!\n");
my %hash;
while (my $eve = <F>){
    chomp ($eve);
    if ($eve =~ /^\w+/){
	my @infor = split/\s+/,$eve;
	my $scaffold_name = $infor[0];
	$infor[7]=~/Name=(.+)/;
	my $gene_name = $1;
#	print "$gene_name\n";
	my $strand = $infor[6];
	$hash{$scaffold_name}{$gene_name}{strand} = $strand;
	my $neweve = "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t.\tParent=$gene_name;\t\n";
	$hash{$scaffold_name}{$gene_name}{cds}.= $neweve;
	my $start = $infor[3];
	my $end = $infor[4];
        push (@{$hash{$scaffold_name}{$gene_name}{start_end}},($start,$end));
    }
}
	
foreach my $scaffold_name(sort keys %hash){
    if (exists $hash{$scaffold_name}){
        foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	   my @cds = sort {$a <=> $b} (@{$hash{$scaffold_name}{$gene_name}{start_end}});
	   print O "$scaffold_name\tsnap\tmRNA\t$cds[0]\t$cds[$#cds]\t.\t$hash{$scaffold_name}{$gene_name}{strand}\t.\tID=$gene_name;\t\n";
	   print O "$hash{$scaffold_name}{$gene_name}{cds}";
	}
    }
}
