#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $genome_file = shift;
my $output = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/03.genescan_prediction/scaffold_output";
#my $eve = 100;
my $sh = $0.".sh";

my $fastafile;
my $fasta_outdir="scaffold";
my $o = 1;
#my $num=1;
#$num记录读到了第几条序列；

open(S,"> $sh") || die ("$!\n");

my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');

while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
#    if ($num%100==1){
#       `mkdir $o `;
#        $fastafile = $o."/".$o.".fa";
    $fastafile = $fasta_outdir."/".$o.".fa";
    print S "/home/user106/user124/software/03.gene_prediction/02.denovo/genescan/genscan /home/user106/user124/software/03.gene_prediction/02.denovo/genescan/Arabidopsis.smat $fastafile >$output/$o.txt\n";
    $o++;
#}
    open (O1,">>$fastafile") || die "$!\n";
    print O1 ">$id\n$seq\n";
    close O1;
#    $num++;
}
close S;
