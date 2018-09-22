#!/usr/bin/perl -w
use strict;
my $num = "04";
my $species = "ptr";
my $sh_file = shift;
my $new_sh = shift;
open (S,"<$sh_file") || (die "$!\n");
open (N,">$new_sh") || (die "$!\n");
my $gffname;
while (my $eve = <S>){
    chomp $eve;
#    ptr14.20684.gff
    if  ($eve =~ /($species(\d+)\.(\d+)\.gff)/){
        $gffname = $1;
#	print "$gffname";
        if (-e "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/04.runGenwise/03.rawgff/$num.$species.gff/$gffname"){
            next;
        }else{
#            print "$gffname\n";
            print N "$eve\n";
        }
    }else{
        print "Match wrong!\n";
    }
}
close S;
close N;
