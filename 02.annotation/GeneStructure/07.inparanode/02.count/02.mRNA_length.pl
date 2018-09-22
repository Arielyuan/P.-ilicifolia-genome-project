#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $pil_gff = "09.f_incompletegene.gff";
my $peu_gff = "v2.Populus_euphratica.gff";
my $sqltable_file = "sqltable.pilpredict.pep-peu.pep";

open (G1,"<$pil_gff" ) or die ("$!\n");
open (G2,"<$peu_gff" ) or die ("$!\n");
open (F,"<$sqltable_file" ) or die ("$!\n");
open (O,">02.mrna_length.txt") or die ("$!\n");
print O "species\tmrna_length\tno\n";
open (O2, ">01.difference.txt") or die "$!\n";

my %pil;
while(my $eve1 = <G1>){
    chomp($eve1);
    my @a1 = split/\s+/,$eve1;
    my $type = $a1[2];
    my $start = $a1[3];
    my $end = $a1[4];
    if ($type eq "mRNA"){
	#ID=evm.model.scaffold20_cov124.2
	$a1[8]=~/evm\.model\.scaffold([^;]+);/;
	my $id = $1;
#	print"$id\n";
	$pil{$id} = $end-$start+1;
#	print "$pil{$id}\n";
    }
}
my %peu;
my %peu_cds;
while(my $eve2 = <G2>){
    chomp($eve2);
    my @a2 = split/\s+/,$eve2;
    my $type = $a2[2];
    my $start = $a2[3];
    my $end = $a2[4];
    if ($type eq "CDS"){
	#Parent=CCG000005.1
        $a2[8]=~/Parent=(.+);/;
        my $id = $1;
	push @{$peu_cds{$id}},$start,$end;
    }
}

foreach my $id (sort keys %peu_cds){
    my @new_array = sort {$a<=>$b} @{$peu_cds{$id}};
    my $mrna_length = $new_array[-1] -$new_array[0] +1;
    $peu{$id} = $mrna_length;
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
foreach my $no (sort keys %hash){
    # my $times = scalar keys %{$hash{$no}};
    my $times = $count{$no};
    if ($times == 2){
        foreach my $species (sort keys %{$hash{$no}}){
            foreach my $id (sort keys %{$hash{$no}{$species}}){
                if($species =~ /pil/){
                    my $mrna_length = $pil{$id};
                    print O "$species\t$pil{$id}\t$no\n";
                    print O2 "pil\t$pil{$id}\t";
                }
                elsif($species =~ /peu/){
                    my $mrna_length = $peu{$id};
                    print O "$species\t$peu{$id}\t$no\n";
                    print O2 "peu\t$peu{$id}\t";
                }
            }
        }
        print O2 "\n";
    }else{
        next;
    }
}

close F;
close O;
close O2;
