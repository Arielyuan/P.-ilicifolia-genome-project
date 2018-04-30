#!/usr/bin/perl -w
#用peu的转录组数据比对到细叶杨的基因组上，来评估细叶杨基因组组装的完整性。
#此脚本用将peu转录组全部的fasta数据拆成每100个文件，并输出比对的sh文件。
use strict;
use Bio::SeqIO;

my $inputfile="Peu.nr.fa";   #胡杨的转录组
my $eve = 5748;   #每个文件里面有多少个fasta
my $sh = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pil-peu.sh"; #输出的sh文件
my $blat = "~/bin/x86_64/blat"; #blat的路径
my $genomefasta = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pilGenome.fa";  #需要评估的基因组文件
my $output = "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/09.blastESTs/01.pil-peu.out";  #blat的输出文件

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

