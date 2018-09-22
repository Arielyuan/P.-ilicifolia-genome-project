#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $inputfile=shift;
my $sh = shift;
my $totalnum=0;
my $splitnum=20;
my $name="rco";
my $o =1;
my $i= 0;
open(S,">$sh") || die "$!\n";

my $fa = Bio::SeqIO->new(-file=>$inputfile, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    $totalnum++;
}

my $fastafile = $name.$o.".fa";
open (O1,">$fastafile") || die "$!\n";
my $eve = int($totalnum/$splitnum)+1;
$fa = Bio::SeqIO->new(-file=>$inputfile, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    $fastafile = $name.$o.".fa";
    print O1 ">$id\n$seq\n";
    $i++;
    if($i>=$eve){
	print S "/home/user106/user124/software/03.gene_prediction/blast-2.2.26/bin/blastall -p tblastn -i $fastafile -d /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/01.database/pilGenome.fa -e 1e-5 -o 01.tbnout.$name.$o -a 8\n";
	close O1;
	$o++;
	$fastafile = $name.$o.".fa";
	$i=0;
	open (O1,">$fastafile") || die "$!\n";
    }
}
print S "/home/user106/user124/software/03.gene_prediction/blast-2.2.26/bin/blastall -p tblastn -i $fastafile -d /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/01.database/pilGenome.fa -e 1e-5 -o 01.tbnout.$name.$o -a 8\n";
close S;
