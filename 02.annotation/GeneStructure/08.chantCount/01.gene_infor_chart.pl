#!/usr/bin/perl -w
use strict;
my $op_count = shift;
my @standard_gff = @ARGV;
open (O,">$op_count") or die ("$!\n");

for (my $j=0;$j<@standard_gff;$j++){
    open (F,"<$standard_gff[$j]") or die ("$!\n");
    my $species_name = $standard_gff[$j];
    print O "$species_name\n";
#    print O "mRNA length\tPercent of genes\tCDs length\tPercent of genes\tExon length\tPercent of genes\tIntron length\tPercent of genes\tExon num\tPercent of genes\t\n";
    my $i = 0;
    my %hash; #这个哈希用来记录具体的信息
    my %num; #这个哈希用来记录个数
    my $gene_num;
    while(my $eve = <F>){
	my @infor = split /\s+/,$eve;
        my $type = $infor[2];
	my $gene_name = $infor[0].".".$i;
        if ($infor[2] eq "mRNA"){
            $gene_num++;
	    my $mRNA_length = $infor[4]-$infor[3]+1;
            $num{mrna_length}{$mRNA_length}++;
	    $i++;
        }elsif($infor[2] eq "CDS"){
            $hash{$gene_name}{exon_num} ++;
	    $hash{$gene_name}{cds_length} += ($infor[4]-$infor[3]+1);
	    my $exon_length = $infor[4]-$infor[3]+1;
	    $num{exon_length}{$exon_length}++;
	    push (@{$hash{$gene_name}{position}},$infor[3],$infor[4]);
        }else{
            next;
        }
    }
    
    foreach my $gene_name (sort keys %hash){
	$num{cds_length}{$hash{$gene_name}{cds_length}}++;
	$num{exon_num}{$hash{$gene_name}{exon_num}}++;
	my $intron_num = scalar @{$hash{$gene_name}{position}};
	if ($intron_num == 2){
	    $num{intron_length}{0}++;
	}else{
	    my @new_intron = sort {$a <=> $b} @{$hash{$gene_name}{position}};
	    for (my $n=1;$n<$intron_num-1;$n=$n+2){
		my $intron_length = $new_intron[$n+1]-$new_intron[$n];
		$num{intron_length}{$intron_length}++;
	    }
	}
    }
    print O "mRNA length\tPercent of genes\t\n";
    foreach my $mrna_length (sort {$a <=> $b} keys %{$num{mrna_length}}){
	my $mrna_per = $num{mrna_length}{$mrna_length}/$gene_num;
	print O "$mrna_length\t$mrna_per\t\n";
    }
    print O "CDs length\tPercent of genes\t\n";
    foreach my $cds_length (sort {$a <=> $b} keys %{$num{cds_length}}){
	my $cds_per = $num{cds_length}{$cds_length}/$gene_num;
	print O "$cds_length\t$cds_per\t\n";
    }
    print O "Exon length\tPercent of genes\t\n";
    foreach my $exon_length (sort {$a <=> $b} keys %{$num{exon_length}}){
        my $exon_length_per = $num{exon_length}{$exon_length}/$gene_num;
        print O "$exon_length\t$exon_length_per\t\n";
    }
    print O "Intron_length\tPercent of genes\t\n";
    foreach my $intron_length (sort {$a <=> $b} keys %{$num{intron_length}}){
        my $intron_per = $num{intron_length}{$intron_length}/$gene_num;
        print O "$intron_length\t$intron_per\t\n";
    }
    print O "Exon_num\tPercent of genes\t\n";
    foreach my $exon_num (sort {$a <=> $b} keys %{$num{exon_num}}){
        my $exon_num_per = $num{exon_num}{$exon_num}/$gene_num;
        print O5 "$exon_num\t$exon_num_per\t\n";
    }
    close F;
}
close O;
