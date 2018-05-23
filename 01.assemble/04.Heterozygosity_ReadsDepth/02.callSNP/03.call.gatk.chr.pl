#! /usr/bin/env perl
# 分scaffold 生成gatk call snp的命令。
use strict;
use warnings;

my $now=$ENV{'PWD'};
my $dict="/home/user106/user124/project/01.Populus_ilicifolia_genome/04.population_analyze/06.callSNP/01.pil/00.ref/pil.Genome.dict";
my $ref="/home/user106/user124/project/01.Populus_ilicifolia_genome/04.population_analyze/06.callSNP/01.pil/00.ref/pil.Genome.fa";
my @bam=</home/user106/user124/project/01.Populus_ilicifolia_genome/04.population_analyze/06.callSNP/01.pil/01.bam/*.bam>;

open(O,"> bam.list");
foreach my $bam(@bam){
    $bam=~/([^\/]+)$/;
    my $name=$1;
    print O "$bam\n";
}
close O;


open(O,"> $0.sh");
open(S,"> $0.supp.sh");
open(I,"< $dict");

my $output_dir = "02.SNPbyChr";
`mkdir $output_dir` if (!-e $output_dir);

while(<I>){
    chomp;
    next unless(/SN:(\S+)\s+LN:(\d+)/);
    my ($chr,$len)=($1,$2);
    my $output_id= $chr;
    `mkdir $now/$output_dir/$output_id` if(!-e "$now/$output_dir/$output_id");
    print O "/home/user106/user124/software/04.gene_analyze/jre1.8.0_121/bin/java -jar /home/user106/user124/software/04.gene_analyze/gatk/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $now/bam.list -L $chr -o $now/$output_dir/$output_id/$output_id.vcf.gz\n";
    if(!-e "$now/$output_dir/$output_id/$output_id.vcf.gz.tbi"){
	print S "/home/user106/user124/software/04.gene_analyze/jre1.8.0_121/bin/java -jar /home/user106/user124/software/04.gene_analyze/gatk/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $now/bam.list -L $chr -o $now/$output_dir/$output_id/$output_id.vcf.gz\n";
    }
}

close I;
close O;
close S;
