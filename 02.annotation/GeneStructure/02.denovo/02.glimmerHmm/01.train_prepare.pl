#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $gff_file = shift;
my $genome_file = shift;
my $op1 = shift; #fasta序列
my $op2 = shift; #cds位置信息的文件
my @scaffold_name;
open (G,"<$genome_file") || die ("!/n");
open (F,"<$gff_file") || die ("!/n");
open (O1,">$op1") || die ("!/n");
open (O2,">$op2") || die ("!/n");
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
my %seq;
my %hash;
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    push(@scaffold_name,$id);
    $seq{$id} = $seq;
}
close G;

while (my $eve = <F>){
    chomp ($eve);
    my @infor = split/\s+/,$eve;
    my $scaffold_name = $infor[0];
    my $type = $infor[2];
    my $gene_name = $infor[8];
    my $strand = $infor[6];
#    if ($type eq "mRNA"){
#	$hash{$scaffold_name}{$gene_name}{start} = $infor[3];
#	$hash{$scaffold_name}{$gene_name}{end} = $infor[4];
#    }
    if ($type eq "CDS"){
	if ($strand eq "-"){
	    $hash{$scaffold_name}{$gene_name} .= $scaffold_name."\t".$infor[4]."\t".$infor[3]."\n";
	}elsif($strand eq "+"){
	    $hash{$scaffold_name}{$gene_name} .= $scaffold_name."\t".$infor[3]."\t".$infor[4]."\n";
	}
    }
}

foreach my $scaffold_name(@scaffold_name){
    if (exists $hash{$scaffold_name}){
	print O1 ">$scaffold_name\n$seq{$scaffold_name}\n";
	foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	    print O2 "$hash{$scaffold_name}{$gene_name}\n";
	}
    }
}
close F;
close O1;
close O2;
