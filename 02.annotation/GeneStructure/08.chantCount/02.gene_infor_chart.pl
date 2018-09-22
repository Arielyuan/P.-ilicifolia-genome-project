#!/usr/bin/perl -iyow
use strict;
my $op_count = shift;
my @standard_gff = @ARGV;
open (O,">$op_count") or die ("$!\n");
print O "param_type\tvalue\tspecies\t\n";
for (my $j=0;$j<@standard_gff;$j++){
    open (F,"<$standard_gff[$j]") or die ("$!\n");
    my $species_name = $standard_gff[$j];
#    print O "param_type\tvalue\tspecies\t\n";
    my $i = 0;
    my %hash; 
    while(my $eve = <F>){
	chomp($eve);
        my @infor = split /\s+/,$eve;
        # my $gene_name = $infor[0].".".$i; # 是这里出错了$gene_name需要从第八列匹配
	if(!$infor[2]){
	    die "$eve\n";
	}
        if ($infor[2] eq "mRNA"){
	    $i++;
	    $infor[8]=~/ID=([^;]+)/;
	    my $gene_name=$1;
            $hash{$gene_name}{mrna_length} = $infor[4]-$infor[3]+1;
        }elsif($infor[2] eq "CDS"){
	    $infor[8]=~/Parent=([^;]+)/;
	    my $gene_name=$1;
            $hash{$gene_name}{exon_num}++;
            $hash{$gene_name}{cds_length} += ($infor[4]-$infor[3]+1);
	    push(@{$hash{$gene_name}{exon_length}},$infor[4]-$infor[3]+1);
            push (@{$hash{$gene_name}{position}},$infor[3],$infor[4]);
	}
    }
    
    foreach my $gene_name (sort keys %hash){
	print O "mRNA_length\t$hash{$gene_name}{mrna_length}\t$species_name\t\n";
	print O "CDS_length\t$hash{$gene_name}{cds_length}\t$species_name\t\n";
	print O "Exon_number\t$hash{$gene_name}{exon_num}\t$species_name\t\n";
	foreach my $exon_length (@{$hash{$gene_name}{exon_length}}){
	    print O "Exon_length\t$exon_length\t$species_name\t\n";
	}
	my $intron_num = scalar @{$hash{$gene_name}{position}};
	if ($intron_num == 2){
	    print O "Intron_length\t0\t$species_name\t\n";
	}else{
	    my @new_intron = sort {$a <=> $b} @{$hash{$gene_name}{position}};
	    for (my $n=1;$n<$intron_num-1;$n=$n+2){
		my $intron_length = $new_intron[$n+1]-$new_intron[$n];
		print O "Intron_length\t$intron_length\t$species_name\t\n";
	    }
	}
    }
    close F;
}
close O;
