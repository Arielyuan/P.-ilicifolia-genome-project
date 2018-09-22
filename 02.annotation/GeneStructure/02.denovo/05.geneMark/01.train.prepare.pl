#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $gff_file = shift;
my $genome_file = shift;
my $op = shift; #intron位置信息的文件
my @scaffold_name;
open (G,"<$genome_file") || die "Cannot read $genome_file!\n";
open (F,"<$gff_file") || die "Cannot read $gff_file!\n";
open (O,">$op") || die "Cannot create $op!\n";
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
my %seq;
my %hash;
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    push(@scaffold_name,$id);
    # $seq{$id} = $seq;
}
close G;

while (my $eve = <F>){
    chomp ($eve);
    my @infor = split/\s+/,$eve;
    my $scaffold_name = $infor[0];
    my $type = $infor[2];
    $infor[8]=~/=([^;]+);/;
    my $gene_name = $1;
    my $strand = $infor[6];
    my $start = $infor[3];
    my $end = $infor[4];
    $hash{$scaffold_name}{$gene_name}{strand} = $strand;
    if ($type eq "mRNA"){
	$hash{$scaffold_name}{$gene_name}{score} = $infor[5];
    }
    if ($type eq "CDS"){
	push (@{$hash{$scaffold_name}{$gene_name}{start_end}},($start,$end));
    }
}

foreach my $scaffold_name(@scaffold_name){
    if (exists $hash{$scaffold_name}){
        foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	    if(!exists $hash{$scaffold_name}{$gene_name}{start_end}){
		print STDERR "$gene_name\n";
	    }
	    my @cds = sort {$a <=> $b} (@{$hash{$scaffold_name}{$gene_name}{start_end}});
	    my $length = scalar (@cds);
	    if ($length>2 && $length%2==0){
		for (my $i=1;$i<$length-1;$i=$i+2){
		    my $intron_start = $cds[$i];
		    my $intron_end = $cds[$i+1];
		    print O "$scaffold_name\tGenewise\tintron\t$intron_start\t$intron_end\t$hash{$scaffold_name}{$gene_name}{score}\t$hash{$scaffold_name}{$gene_name}{strand}\t.\t.\t\n";
		}
	    }elsif($length%2 != 0){
		print "WRONG!!\n";
		last;
	    }
	}
    }
}
close F;
close O;
