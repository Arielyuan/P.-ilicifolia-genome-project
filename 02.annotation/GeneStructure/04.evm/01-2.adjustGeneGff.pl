#!/usr/bin/perl -w
#Contig1 fgenesh gene    26480   29114   .       +       .       ID=1.tPRED000001;Name=fgenesh model 1.m000001
#Contig1 fgenesh mRNA    26480   29114   .       +       .       ID=1.m000001;Parent=1.tPRED000001
#Contig1 fgenesh exon    26480   26499   .       +       .       ID=1.e000001;Parent=1.m000001
#Contig1 fgenesh CDS     26480   26499   .       +       0       ID=cds_of_1.m000001;Parent=1.m000001
use strict;
my $ipgff = shift;
my $opgff = shift;
open (I,"<$ipgff") or die ("$!\n");
open (O,">$opgff") or die ("$!\n");
my %hash;
my $gene_name;
my $mRNA_id = 1;
my $exon_id = 0;
my $cds_id;
my $exon_num;
while (my $eve = <I>){
    chomp ($eve);
    my @infor = split /\s+/,$eve;
    if ($infor[8] =~ /(\w+)=(.+);/){
	$gene_name = $2;
    }	
    my $software = $infor[1];
    my $type = $infor[2];
    if ($type eq "mRNA"){
	my $gene = $infor[0]."\t".$infor[1]."\t"."gene"."\t".$infor[3]."\t".$infor[4]."\t".$infor[5]."\t".$infor[6]."\t".$infor[7];
	my $mRNA = $infor[0]."\t".$infor[1]."\t"."mRNA"."\t".$infor[3]."\t".$infor[4]."\t".$infor[5]."\t".$infor[6]."\t".$infor[7];
	$hash{$software}{$gene_name}{gene} = $gene."\t"."ID=PIL".$mRNA_id.";Name=".$software." model m".$mRNA_id."\t\n";
	$hash{$software}{$gene_name}{mRNA} = $mRNA."\t"."ID=m".$mRNA_id.";Parent=PIL".$mRNA_id."\t\n";
	$mRNA_id++;        
#	print "$mRNA_id\n";
   }elsif ($type eq "CDS"){
       my $cds = $infor[0]."\t".$infor[1]."\t"."CDS"."\t".$infor[3]."\t".$infor[4]."\t".$infor[5]."\t".$infor[6]."\t".$infor[7]."\t";
       $hash{$software}{$gene_name}{strand} = $infor[6];
       push (@{$hash{$software}{$gene_name}{cds}},$cds);
   }
}
close I;

foreach my $software (sort keys %hash){
#    print "$software\n";
    foreach my $gene_name (sort keys %{$hash{$software}}){
	if(!exists $hash{$software}{$gene_name}{gene}){
	    die "$software\t$gene_name\n";
	}
	print O "$hash{$software}{$gene_name}{gene}";
	print O "$hash{$software}{$gene_name}{mRNA}";
	if ($hash{$software}{$gene_name}{mRNA} =~ /(.+)ID=(.+);/){ #ID=1.m000001 
	    $cds_id = $2;
	}else{
	    print "match wrong!!\n";
	}
	if ($hash{$software}{$gene_name}{strand} eq "+"){
	    foreach my $cds (@{$hash{$software}{$gene_name}{cds}}){
		my @array = split /\s+/,$cds;
		$exon_id ++;	
		print O "$array[0]\t$array[1]\texon\t$array[3]\t$array[4]\t$array[5]\t$array[6]\t$array[7]\tID=e$exon_id;Parent=$cds_id\t\n";
		print O $cds."ID=cds_of_".$cds_id.";Parent=".$cds_id."\t\n";
	    }
	}
	elsif ($hash{$software}{$gene_name}{strand} eq "-"){
	    $exon_num = scalar (@{$hash{$software}{$gene_name}{cds}});
	    my @a=@{$hash{$software}{$gene_name}{cds}};
	    @a=reverse(@a);
	    @{$hash{$software}{$gene_name}{cds}}=@a;
#	    @{$hash{$software}{$gene_name}{cds}} = reverse @{$hash{$software}{$gene_name}{cds}};
	    $exon_id += $exon_num;
	    my $minus_id;
	    $minus_id = $exon_id;
	    foreach my $cds (@{$hash{$software}{$gene_name}{cds}}){
		my @array = split /\s+/,$cds;
		print O "$array[0]\t$array[1]\texon\t$array[3]\t$array[4]\t$array[5]\t$array[6]\t$array[7]\tID=e$minus_id;Parent=$cds_id\t\n";
		print O $cds."ID=cds_of_".$cds_id.";Parent=".$cds_id."\t\n";
		$minus_id -- ;
	    }
	}
    }
}
close O;
