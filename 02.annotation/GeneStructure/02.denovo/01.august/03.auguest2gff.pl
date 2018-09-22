#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_standard_gff = shift;
open (F,"<$gff_file") || die ("!\n");
open (O,">$op_standard_gff") || die ("!\n");
my $i = 0;
my %hash;
while (my $eve = <F>){
    chomp ($eve);
    if ($eve =~ /^\w+/){
	my @infor = split/\s+/,$eve;
	my $type = $infor[2];
	my $scaffold_name = $infor[0];
	if ($type eq "gene"){
	    $i++;
	    $infor[8] = "Parent=".$scaffold_name.".".$i;
	    my $gene_name = $scaffold_name.".".$i;
	    $hash{$scaffold_name}{$gene_name}{score} = $infor[5];
	    $hash{$scaffold_name}{$gene_name}{strand} = $infor[6];
	}elsif($type eq "CDS"){
	    $infor[8] = "ID=".$scaffold_name.".".$i;
	    my $gene_name = $scaffold_name.".".$i;
	    my $neweve = "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\t$infor[8];\t\n";
	    $hash{$scaffold_name}{$gene_name}{cds}.= $neweve;
	}elsif($type eq "stop_codon"){
	    $infor[8] = "ID=".$scaffold_name.".".$i;
	    my $gene_name = $scaffold_name.".".$i;
	    my $neweve = "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\t$infor[8];\t\n";
	    $hash{$scaffold_name}{$gene_name}{stop_codon}{start} = $infor[3];
	    $hash{$scaffold_name}{$gene_name}{stop_codon}{end} = $infor[4];
	}else{
	    next;
	}
    }
}
close F;
foreach my $scaffold_name(sort keys %hash){
    if (exists $hash{$scaffold_name}){
        foreach my $gene_name(sort keys %{$hash{$scaffold_name}}){
	    my @array;
	    my @first;
	    my @last;
	    if ($hash{$scaffold_name}{$gene_name}{strand} eq "+"){
		if (exists $hash{$scaffold_name}{$gene_name}{stop_codon}){
		    @array = split/\n/,$hash{$scaffold_name}{$gene_name}{cds};
		    my $firstcds = $array[0];
		    my $lastcds = $array[-1];
		    @first = split/\t/,$firstcds;
		    @last = split/\t/,$lastcds;
		    my $step = $first[7];
		    $first[3] = $first[3]+$step;
		    my $mrna_start = $first[3]+$first[7];
		    my $mrna_end = $hash{$scaffold_name}{$gene_name}{stop_codon}{end};
		    $last[4] = $hash{$scaffold_name}{$gene_name}{stop_codon}{end};
		    my $newstartcds = join "\t",@first;
		    my $newlastcds = join "\t",@last;
		    $array[0] = $newstartcds;
		    $array[-1] = $newlastcds;
		    my $newcds = join "\n",@array;
		    print O "$scaffold_name\tAUGUSTUS\tmRNA\t$mrna_start\t$mrna_end\t$hash{$scaffold_name}{$gene_name}{score}\t$hash{$scaffold_name}{$gene_name}{strand}\t.\tParent=$gene_name;\t\n";
		    print O "$newcds\n";
		}else{
		    @array = split/\n/,$hash{$scaffold_name}{$gene_name}{cds};
		    my $firstcds = $array[0];
		    my $lastcds = $array[-1];
		    @first = split/\t/,$firstcds;
		    @last = split/\t/,$lastcds;
		    my $step = $first[7];
		    $first[3] = $first[3]+$step;
		    my $mrna_start = $first[3];
		    my $mrna_end = $last[4];
		    my $newfirstcds = join "\t",@first;
		    $array[0] = $newfirstcds;
		    my $newcds = join "\n",@array;
		    print O "$scaffold_name\tAUGUSTUS\tmRNA\t$mrna_start\t$mrna_end\t$hash{$scaffold_name}{$gene_name}{score}\t$hash{$scaffold_name}{$gene_name}{strand}\t.\tParent=$gene_name;\t\n";
		    print O "$newcds\n";
		}
	    }
	    elsif($hash{$scaffold_name}{$gene_name}{strand} eq "-"){
		if(exists $hash{$scaffold_name}{$gene_name}{stop_codon}){
		    @array = split/\n/,$hash{$scaffold_name}{$gene_name}{cds};
		    my $lastcds = $array[-1];
		    @last = split/\t/,$lastcds;
		    my $step = $last[7];
		    $last[4] = $last[4] - $step;
		    my $firstcds = $array[0];
		    @first = split/\t/,$firstcds;
		    $first[3] = $hash{$scaffold_name}{$gene_name}{stop_codon}{start};
		    my $mrna_start = $first[3];
		    my $mrna_end = $last[4];
		    my $newfirstcds = join "\t",@first;
		    my $newlastcds = join "\t",@last;
		    $array[0] = $newfirstcds;
                    $array[-1] = $newlastcds;
                    my $newcds = join "\n",@array;
                    print O "$scaffold_name\tAUGUSTUS\tmRNA\t$mrna_start\t$mrna_end\t$hash{$scaffold_name}{$gene_name}{score}\t$hash{$scaffold_name}{$gene_name}{strand}\t.\tParent=$gene_name;\t\n";
                    print O "$newcds\n";
		}else{
		    @array = split/\n/,$hash{$scaffold_name}{$gene_name}{cds};
		    my $lastcds = $array[-1];
		    @last = split/\t/,$lastcds;
                    my $step = $last[7];
                    $last[4] = $last[4] - $step;
		    my $firstcds = $array[0];
		    my @first = split/\t/,$firstcds;
		    my $mrna_start = $first[3];
                    my $mrna_end = $last[4];
                    my $newlastcds = join "\t",@last;
                    $array[-1] = $newlastcds;
                    my $newcds = join "\n",@array;
                    print O "$scaffold_name\tAUGUSTUS\tmRNA\t$mrna_start\t$mrna_end\t$hash{$scaffold_name}{$gene_name}{score}\t$hash{$scaffold_name}{$gene_name}{strand}\t.\tParent=$gene_name;\t\n";
                    print O "$newcds\n";
                }
	    }
	}
    }
}
close O;
