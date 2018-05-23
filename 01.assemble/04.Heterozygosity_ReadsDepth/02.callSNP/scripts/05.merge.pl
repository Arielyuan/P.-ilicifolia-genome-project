#! /usr/bin/env perl
use strict;
use warnings;

my $in_dir="02.SNPbyChr";
#my $out_file="$0.vcf.gz";
my $out_file = "05.pil.merge.phase.vcf.gz";
my @dir=<$in_dir/*>;

my %hash;
foreach my $dir(@dir){
    #scaffold275_cov124 scaffold275.1.fQC.vcf.gz
    $dir=~/02.SNPbyChr\/(scaffold(\d+)_cov\d+)/;
    my $num=$2;
    $hash{$num}=$1;
}
open(O,"| gzip - > $out_file");
my $control=0;
foreach my $num(sort {$a<=>$b} keys %hash){
    my $name=$hash{$num};
    #my $vcf="02.SNPbyChr"."/".$name."/".$name.".fQC.vcf.gz";
    #phase.vcf.gz.vcf.gz
    my $vcf = "02.SNPbyChr"."/".$name."/".$name.".phase.vcf.gz.vcf.gz";
    next if (! -e $vcf);
    print STDERR "$vcf\n";
    open(I,"zcat $vcf |");
    while(<I>){
        if(/^#/){
            print O "$_" if($control==0);
        }
        else{
            print O "$_";
        }
    }
    close I;
    $control++;
}
close O;
