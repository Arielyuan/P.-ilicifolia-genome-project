#!/usr/bin/perl -w
use strict;

my $ref = "/share/work/user124/huyang_sex/PeuGenome.fa";
my $dict = "/share/work/user124/huyang_sex/PeuGenome.dict";
my $bamList="01.bam.list";
my $vcf_dir = "02.vcf";
my $op = $0.".sh";
open (O,">$op") or die ("$!\n");
`mkdir $vcf_dir` if (! -e $vcf_dir);
open (F,"<$dict") or die ("$!\n");

while (my $eve = <F>){
    chomp($eve);
#SN:scaffold23.1
    next unless ($eve =~ (/SN:(scaffold(\d+)\.(\d+))/));
    my $chr=$1;
    print O "/home/share/user/user101/software/samtools/samtools/samtools mpileup -A -ug -t DP -t SP -t DP4 -f $ref -r $chr -b $bamList | /share/work/software/bcftools/bcftools-1.2/bcftools call -vmO z -o $vcf_dir/$chr.vcf.gz\n";
}

close O;
