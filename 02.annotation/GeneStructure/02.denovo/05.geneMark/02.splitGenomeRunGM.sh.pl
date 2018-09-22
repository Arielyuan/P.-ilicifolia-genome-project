#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $genome_file = shift;
my $output_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/05.geneMark_prediction/scaffold_output";
my $gmhmme3_path = "/home/user106/user124/software/03.gene_prediction/02.denovo/gm_et_linux_64/gmes_petap/gmhmme3";
my $parameter = "-m /home/user106/user124/software/03.gene_prediction/02.denovo/genemark_hmm_euk_linux_64/ehmm/a_thaliana.mod -f gff3";
my $genome_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/05.geneMark_prediction/scaffold/";
my $sh = $0.".sh";
my $fastafile;
my $o = 1;
#my $num = 1;
#/home/user106/user124/software/03.gene_prediction/02.denovo/gm_et_linux_64/gmes_petap/gmhmme3 00.pilGenome.fa -m /home/user106/user124/software/03.gene_prediction/02.denovo/genemark_hmm_euk_linux_64/ehmm/a_thaliana.mod -o pilGM.gff -f gff3
open(S,">$0.sh") || die ("$!\n");
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
#    if ($num%100==1){
#        `mkdir $o `;
    $fastafile = $o.".fa";
    print S "$gmhmme3_path $genome_path$fastafile $parameter -o $output_path/$o.txt\n";
    $o++;
#    }
    open (O1,">>$fastafile") || die "$!\n";
    print O1 ">$id\n$seq\n";
    close O1;
#    $num++;
}

close S;
