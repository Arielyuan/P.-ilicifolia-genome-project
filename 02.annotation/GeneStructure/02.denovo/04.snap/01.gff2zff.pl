#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $gff_file = shift;
my $genome_file = shift;
my $op1 = shift; #fasta序列文件
my $op2 = shift; #zff格式的文件
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
    $infor[8]=~/=([^;]+);/;
    my $gene_name = $1;
    my $strand = $infor[6];
    $hash{$scaffold_name}{$gene_name}{strand} = $strand;
    my $start = $infor[3];
    my $end = $infor[4];
    if ($type eq "CDS"){
	$hash{$scaffold_name}{$gene_name}{gene_length} += ($end-$start+1);
        push (@{$hash{$scaffold_name}{$gene_name}{start_end}},($start,$end));
    }
    print "@{$hash{$scaffold_name}{$gene_name}{start_end}}\n";
}
foreach my $scaffold_name(@scaffold_name){
    if (exists $hash{$scaffold_name}){
	print O1 ">$scaffold_name\n$seq{$scaffold_name}\n";
	print O2 ">$scaffold_name\n";
	foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	    if ($hash{$scaffold_name}{$gene_name}{gene_length}%3 == 0){
		my @cds;
		my $gene_length = 0;
		if(!exists $hash{$scaffold_name}{$gene_name}{start_end}){
		    print STDERR "$gene_name\n";
		}
		if ($hash{$scaffold_name}{$gene_name}{strand} eq "+"){
		    @cds = sort {$a <=> $b} (@{$hash{$scaffold_name}{$gene_name}{start_end}});
		}elsif ($hash{$scaffold_name}{$gene_name}{strand} eq "-"){
		    @cds = sort {$b <=> $a} (@{$hash{$scaffold_name}{$gene_name}{start_end}});
		}
		my $length = scalar (@cds);
		if ($hash{$scaffold_name}{$gene_name}{strand} eq "+"){
		    if ($length ==2){
			print O2 "Esngl\t$cds[0]\t$cds[1]\t$gene_name\n";
		    }elsif ($length ==4){
			print O2 "Einit\t$cds[0]\t$cds[1]\t$gene_name\n";
			print O2 "Eterm\t$cds[2]\t$cds[3]\t$gene_name\n";
		    }else{
			print O2 "Einit\t$cds[0]\t$cds[1]\t$gene_name\n";
		    for (my $i=2;$i<$length-2;$i=$i+2){
			print O2 "Exon\t$cds[$i]\t$cds[$i+1]\t$gene_name\n";
		    }
			print O2 "Eterm\t$cds[$length-2]\t$cds[$length-1]\t$gene_name\n"
		    }
		}elsif($hash{$scaffold_name}{$gene_name}{strand} eq "-"){
		    if ($length ==2){
			print O2 "Esngl\t$cds[0]\t$cds[1]\t$gene_name\n";
		    }elsif ($length ==4){
			print O2 "Einit\t$cds[0]\t$cds[1]\t$gene_name\n";
			print O2 "Eterm\t$cds[2]\t$cds[3]\t$gene_name\n";
		    }else{
			print O2 "Einit\t$cds[0]\t$cds[1]\t$gene_name\n";
			for (my $i=2;$i<$length-2;$i=$i+2){
			    print O2 "Exon\t$cds[$i]\t$cds[$i+1]\t$gene_name\n";
			}
			print O2 "Eterm\t$cds[$length-2]\t$cds[$length-1]\t$gene_name\n"
		    }
		}
	    }
	}
    }
}
close F;
close O1;
close O2;
