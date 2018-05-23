#!/usr/bin/perl -w
use strict;
my @ip = glob "02.SNPbyChr/*/*.vcf.gz";
my $op = $0.".sh";
open (O,">$op") or die ("$!\n");

#./03.add.all.site.pl 02.SNPbyChr/scaffold275.1/scaffold275.1.vcf.gz
foreach my $ip (@ip){
    print O "./03.add.allsite.removeindel5bp.pl $ip\n";
}

close O;
