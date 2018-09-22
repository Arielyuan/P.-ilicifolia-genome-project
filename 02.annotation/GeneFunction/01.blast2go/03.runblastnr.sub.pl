#! /usr/bin/env perl
use strict;
use warnings;
#"/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query $fastafile -db /home/share/data/genome/blastDB/20140727_161738/nr -outfmt 5 -num_threads 10 -out 01.blastnr1to1.out/pil$id.xml\n

my $input_dir="01.pil.1to1.scaffolds";
my $output_dir="01.blastnr1to1.pbs.out";

`mkdir $output_dir` if(!-e $output_dir);
my @pep=<$input_dir/*.fa>;
open(O,"> $0.sh");
foreach my $pep(@pep){
    $pep=~/\/([^\/]+)$/;
    my $output_id=$1;
    print O "/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query $pep -db /home/share/data/genome/blastDB/20140727_161738/nr -outfmt 5 -num_threads 10 -out $output_dir/pil$output_id.xml\n";
}
close O;
