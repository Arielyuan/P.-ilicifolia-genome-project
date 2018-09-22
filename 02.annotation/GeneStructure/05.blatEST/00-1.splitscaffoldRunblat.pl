#!/usr/bin/perl -w
#此脚本用于将基因组fasta文件分成每100条($eve)scaffold一个文件，并将输出sh文件；

use strict;
use Bio::SeqIO;
my $inputfile=shift;
my $eve = 5748;
my $sh = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pil-peu.sh";
my $blat = "~/bin/x86_64/blat";
my $genomefasta = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pilGenome.fa";
my $output = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pil-peu.out";
my $fastafile;
my $o =1;
my $num=1;
#$num记录读到了第几条序列；

open(S,">$sh") || die "$!\n";
my $fa = Bio::SeqIO->new(-file=>$inputfile, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    if ($num%($eve)==1){
        $fastafile = "01.peu.scaffolds/".$o.".fa";
        $o++;
        print S "$blat $genomefasta $fastafile -out=blast8 -fine $output/$o.gff\n";
    }
    open (O1,">>$fastafile") || die ("$!\n");
    print O1 ">$id\n$seq\n";
    close O1;
    $num++;
}
