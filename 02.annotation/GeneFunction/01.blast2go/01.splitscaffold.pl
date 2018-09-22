#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $inputfile="pil.pep";
my $sh = "01.blastnr_1to1.sh";
my $out_dir = "01.pil.1to1.scaffolds";
`mkdir $out_dir` if (!-e $out_dir);
open (S,">$sh") or die ("$!\n");
my $fa = Bio::SeqIO->new(-file=>$inputfile, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $fastafile = $out_dir."/".$id.".fa";
    print S "/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query $fastafile -db /home/share/data/genome/blastDB/20140727_161738/nr -outfmt 5 -num_threads 10 -out 01.blastnr1to1.out/pil$id.xml\n";
    open (O1,">>$fastafile") || die ("$!\n");
    print O1 ">$id\n$seq\n";
    close O1;
}
close S;
