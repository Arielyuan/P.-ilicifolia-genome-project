#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
#/home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/bin/glimmerhmm_linux_x86_64 /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold/1.fa -d /home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/trained_dir/arabidopsis/ -g -f >/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold_output/1.txt
my $genome_file = shift;
my $output_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold_output";
my $glimmerhmm_path = "/home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/bin/glimmerhmm_linux_x86_64";
my $parameter = "-d /home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/trained_dir/arabidopsis/ -g -f";
my $genome_path = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold/";
my $sh = $0.".sh";
my $fastafile;
my $o = 1;
#my $num = 1;
#/home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/bin/glimmerhmm_linux_x86_64 /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold/1.fa -d /home/user106/user124/software/03.gene_prediction/02.denovo/GlimmerHMM/trained_dir/arabidopsis/ -g -f >/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/02.glimmerHmm_prediction/02.scaffold_output/1.txt
open(S,">$0.sh") || die ("$!\n");
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
#    if ($num%100==1){
#        `mkdir $o `;
    $fastafile = $o.".fa";
    print S "$glimmerhmm_path $genome_path$fastafile $parameter >$output_path/$o.txt\n";
    $o++;
#    }
    open (O1,">>$fastafile") || die "$!\n";
    print O1 ">$id\n$seq\n";
    close O1;
#    $num++;
}

close S;
