#!/usr/bin/perl -w
use strict;
my $op_standard_gff = shift;
my @gff_file = @ARGV;
my $j=0;
open (O,">$op_standard_gff") || die ("!\n");
foreach (my $i=0;$i<@ARGV;$i++){
    open (F,"<$gff_file[$i]") || die ("!\n");
    <F>;
    <F>;
    <F>;
    # 第四行：“FASTA defline: >scaffold36164_cov2529”
    my $scaffold_name;
    my $scaffold_line = <F>;
    chomp ($scaffold_line);
    if ($scaffold_line =~ /FASTA defline: >(.+)/){
	$scaffold_name = $1;
    }
    my %hash;
    while (my $eve = <F>){
	next if ($eve =~ /^#/);
	chomp($eve);
	my @infor = split/\s+/,$eve;
	if($infor[2] eq "mRNA" && $infor[6] eq "+"){
	    $j++;
	    my $gene_name = $scaffold_name.".".$j;
	    print O "$scaffold_name\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\tID=$gene_name;\t\n";
	}elsif($infor[2] eq "CDS" && $infor[6] eq "+"){
	    my $gene_name = $scaffold_name.".".$j;
	    print O "$scaffold_name\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\tParent=$gene_name;\t\n";
	}elsif ($infor[2] eq "mRNA" && $infor[6] eq "-"){
	    $j++;
	    my $gene_name = $scaffold_name.".".$j;
	    $hash{$gene_name}{mRNA} = "$scaffold_name\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\tID=$gene_name;\t\n";
	}elsif ($infor[2] eq "CDS" && $infor[6] eq "-"){
	    my $gene_name = $scaffold_name.".".$j;
	    my $start = $infor[3];
	    $hash{$gene_name}{CDS}{$start} = "$scaffold_name\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\tParent=$gene_name;\t\n";
	}
    }
    foreach my $gene_name (sort keys %hash){
	if (exists $hash{$gene_name}){
	    print O "$hash{$gene_name}{mRNA}";
	    foreach my $start (sort {$b <=> $a} keys %{$hash{$gene_name}{CDS}}){
		print O "$hash{$gene_name}{CDS}{$start}";
	    }
	}
    }		
    close F;
}
close O;
