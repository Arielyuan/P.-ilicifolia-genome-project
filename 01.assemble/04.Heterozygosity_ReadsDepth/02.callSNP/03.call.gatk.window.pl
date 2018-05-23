#! /usr/bin/env perl
use strict;
use warnings;

my $now=$ENV{'PWD'};
my $dict="/share/work/user124/project/01.Populus_ilicifolia_genome/06.popululation_analyze/05.Salicaceae.compare/pil.Genome.dict";
my $ref="/share/work/user124/project/01.Populus_ilicifolia_genome/06.popululation_analyze/05.Salicaceae.compare/pil.Genome.fa";
my @bam=</share/work/user124/project/01.Populus_ilicifolia_genome/08.heter.analyze/02.supple_bwa/05.all.realian.bam/PPr*.bam>;
my $output_dir="01.vcfByWindow";
`mkdir $now/$output_dir` if(!-e "$now/$output_dir");
my $outlier=1000000;

open(O,"> bam.list");
foreach my $bam(@bam){
    # next if($bam=~/pro01-b/);
    $bam=~/([^\/]+)$/;
    my $name=$1;
    #next if($name=~/pad/ || $name=~/pda/ || $name=~/pro/ || $name=~/pqi/ || $name=~/pal/ || $name=~/pca/ || $name=~/pmo/);
    print O "$bam\n";
}
close O;


open(O,"> $0.sh");
open(S,"> $0.supp.sh");
my $output_id=0;
`mkdir $now/$output_dir/$output_id` if(!-e "$now/$output_dir/$output_id");
open(L,"> $now/$output_dir/$output_id/intervals.list");
print O "/home/share/software/java/jdk1.8.0_05/bin/java -jar /home/share/user/user101/software/GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $now/bam.list -L $now/$output_dir/$output_id/intervals.list -o $now/$output_dir/$output_id/$output_id.vcf.gz\n";
my $accumulate=0;
open(I,"< $dict");
while(<I>){
    chomp;
    next unless(/SN:(\S+)\s+LN:(\d+)/);
    my ($chr,$len)=($1,$2);
    my $left=$len;
    my $start_pos=1;
    while($left>0){
        if($accumulate >= $outlier){
            $output_id ++;
            close L;
            `mkdir $now/$output_dir/$output_id` if(!-e "$now/$output_dir/$output_id");
            open(L,"> $now/$output_dir/$output_id/intervals.list");
            print O "/home/share/software/java/jdk1.8.0_05/bin/java -jar /home/share/user/user101/software/GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $now/bam.list -L $now/$output_dir/$output_id/intervals.list -o $now/$output_dir/$output_id/$output_id.vcf.gz\n";
            if(!-e "$now/$output_dir/$output_id/$output_id.vcf.gz.tbi"){
                print S "/share/work/user124/software/05.gene_analyze/java/jre1.8.0_121/bin/java -jar /share/work/user124/software/05.gene_analyze/gatk-3.7/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $now/bam.list -L $now/$output_dir/$output_id/intervals.list -o $now/$output_dir/$output_id/$output_id.vcf.gz\n";
            }
            $accumulate = 0;
        }
        my $cut_length = $outlier-$accumulate;
        if($cut_length <= $left){
            $left -= $cut_length;
        }
        else{
            $cut_length=$left;
            $left=0;
        }
        $accumulate+=$cut_length;
        my $end_pos=$cut_length+$start_pos-1;
#        print "$output_id\tlen: $len\tcut_length: $cut_length\tleft: $left\taccumulate: $accumulate\t$chr:$start_pos-$end_pos\ n";
        print L "$chr:$start_pos-$end_pos\n";
	
        $start_pos+=$cut_length;
    }
}
close I;
close L;
close O;
close S;
