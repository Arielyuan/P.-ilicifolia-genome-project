#!/usr/bin/perl -w

#./04.filterQualityDepthMiss.pl 01.bam/01.peu.depth.count 02.SNPbyChr/scaffold275.1/scaffold275.1.allsite.vcf.gz
use strict;
my @ip = glob "02.SNPbyChr/*/*.allsite.vcf.gz";
my $op = $0.".sh";
open (O,">$op") or die ("$!\n");
my $op_dir = "07.internal.difference.out";
`mkdir $op_dir` if (! -e $op_dir);
foreach my $ip (@ip){
    $ip =~/02.SNPbyChr\/(.+)\//;
    my $prefix =$1;
    my $op = $op_dir."/".$prefix.".out";
    print O "./07.internal.difference.pl $ip $op\n";
}

close O;
