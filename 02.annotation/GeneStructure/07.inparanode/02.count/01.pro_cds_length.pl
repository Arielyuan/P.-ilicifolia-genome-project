#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $pil_fa = "pilpredict.pep";
my $peu_fa = "peu.pep";
my $sqltable_file = shift;

open (G1,"<$pil_fa" ) or die ("$!\n");
open (G2,"<$peu_fa" ) or die ("$!\n");
open (F,"<$sqltable_file" ) or die ("$!\n");
open (O,">01.protein_length.txt") or die ("$!\n");
open (O3,">01.cds_length.txt") or die ("$!\n");
print O "species\tprotein_length\tno\n";
print O3 "species\tcds_length\tno\n";
open (O2, ">01.difference.txt") or die "$!\n";

my %pil;
my $fa1 = Bio::SeqIO->new(-file=>$pil_fa, -format=>'fasta');
while(my $seq = $fa1->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $pil_length = length ($seq);
    $pil{$id} = $pil_length;
}

my %peu;
my $fa2 = Bio::SeqIO->new(-file=>$peu_fa, -format=>'fasta');
while(my $seq = $fa2->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $peu_length = length ($seq);
    $peu{$id} = $peu_length;
}

close G1;
close G2;
my %hash;
my %count;
while (my $eve = <F>){
    my @a = split/\s+/,$eve;
    my $no = $a[0];
    my $id = $a[4];
    my $species = $a[2];
    $count{$no}++;
    $hash{$no}{$species}{$id}++;
}
#是统计homolog 1:1 的吗
foreach my $no (sort keys %hash){
    # my $times = scalar keys %{$hash{$no}};
    my $times = $count{$no};
    if ($times == 2){
	foreach my $species (sort keys %{$hash{$no}}){
	    foreach my $id (sort keys %{$hash{$no}{$species}}){
		# print O "$species\t$pil{$id}\t\n";	
		# print O "$species\t$peu{$id}\t\n";
		if($species =~ /pil/){
		    my $cds_length = $pil{$id}*3;
		    print O "$species\t$pil{$id}\t$no\n";
		    print O2 "pil\t$pil{$id}\t";
		    print O3 "$species\t$cds_length\t$no\n";
		}
		elsif($species =~ /peu/){
		    my $cds_length = $peu{$id}*3;
		    print O "$species\t$peu{$id}\t$no\n";
		    print O2 "peu\t$peu{$id}\t";
		    print O3 "$species\t$cds_length\t$no\n";
		}
	    }
	}
	print O2 "\n";
    }else{
	next;
    }
}

#print O "1vs1_num is $vs1_num\n";
close F;
close O;
close O2;
close O3;
