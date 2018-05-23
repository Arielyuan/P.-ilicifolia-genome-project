#!/usr/bin/perl -w

#./04.filterQualityDepthMiss.pl 01.bam/01.peu.depth.count 02.SNPbyChr/scaffold275.1/scaffold275.1.allsite.vcf.gz
use strict;
my @ip = glob "02.SNPbyChr/*/*.allsite.vcf.gz";
my $op = $0.".sh";
my $depth = "01.bam/01.pil.depth.count";
open (O,">$op") or die ("$!\n");

foreach my $ip (@ip){
    print O "./04.filterQualityDepthMiss.pl $depth $ip\n";
}

close O;
