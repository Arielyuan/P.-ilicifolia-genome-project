#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $genome_file = shift;
my $output_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/01.augustus_prediction/02.scaffold_output";
my $augustus_path = "/home/user106/user124/software/03.gene_prediction/02.denovo/augustus-3.2.1/bin/augustus";
my $parameter = "--gff3=on --strand=both --species=pilnewformatefinal";
my $genome_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/01.augustus_prediction/02.scaffold/";
my $sh = $0.".sh";
my $eve = 100;
my $fastafile;
my $o = 1;
my $num=1;
#$num记录读到了第几条序列；
#/home/user106/user124/software/03.gene_prediction/02.denovo/augustus-3.2.1/bin/augustus --gff3=on --strand=both --species=pilnewformatefinal /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/01.augustus_prediction/00.pilGenome.fa
open(S,">$0.sh") || die ("$!\n");
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    if ($num%100==1){
        `mkdir $o `;
        $fastafile = $o."/".$o.".fa";
        print S "$augustus_path $parameter $genome_path$fastafile >$output_path/$o.txt\n";
	$o++;
    }
    open (O1,">>$fastafile") || die "$!\n";
    print O1 ">$id\n$seq\n";
    close O1;
    $num++;
}
close S;
