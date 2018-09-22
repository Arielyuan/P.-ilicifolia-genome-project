#! /usr/bin/env perl
use strict;
use warnings;
#/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query pil.pep -db pil_swissprot -evalue 1e-5 -outfmt 6 -num_threads 10 -out 01.swissprot_blastp.out

my $input_dir="00.pil.100.pep";
my $output_dir="01.pil_swp_result";

`mkdir $output_dir` if(!-e $output_dir);
my @pep=<$input_dir/*.pep>;
open(O,"> $0.sh");
foreach my $pep(@pep){
    $pep=~/\/([^\/]+)$/;
    my $output_id=$1;
    print O "/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query $pep -db pil_swissprot -evalue 1e-5 -outfmt 6 -num_threads 10 -out $output_dir/$output_id.tab\n";
}
close O;
