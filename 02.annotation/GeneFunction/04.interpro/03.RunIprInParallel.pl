#! /usr/bin/env perl
use strict;
use warnings;
# export PATH=/home/share/software/java/jdk1.8.0_05/bin:$PATH;./interproscan.sh -i pil_noxing.pep -f gff3 -o 01.pil_interpro_out

my $input_dir="00.pil_noxing.pep";
my $output_dir="01.pil_ipr_result";

`mkdir $output_dir` if(!-e $output_dir);
my @pep=<$input_dir/*.pep>;
open(O,"> $0.sh");
foreach my $pep(@pep){
    $pep=~/\/([^\/]+)$/;
    my $output_id=$1;
    print O "export PATH=/home/share/software/java/jdk1.8.0_05/bin:\$PATH;./interproscan.sh -i $pep -f gff3 -o $output_dir/$output_id.annot\n";
}
close O;
