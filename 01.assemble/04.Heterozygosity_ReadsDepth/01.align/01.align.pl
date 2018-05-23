#!/usr/bin/perl -w
use strict;
my @ip = glob "/share/work/user124/project/01.Populus_ilicifolia_genome/09.pil-peu-ptr.analyze/01.bam/05.ppr/00.reads/*.fq.gz";
my $op = $0.".sh";
my $op2 = "02.rmdup.sh";
my $op3 = "03.rungatk.sh";
open (O,">$op") or die ("$!\n");
open (O2,">$op2") or die ("$!\n");
open (O3,">$op3") or die ("$!\n");
my $ref = "/share/work/user124/project/01.Populus_ilicifolia_genome/09.pil-peu-ptr.analyze/01.bam/05.ppr/00.genome/Ppr_genome.fa";
my $bwa = "/share/work/software/bwa/bwa-0.7.12/bwa";
my $samtools = "/share/work/user124/software/02.genome_assemble/sametools/samtools";
my $java = "/share/work/software/java/jdk1.8.0_60/bin/java";
my $gatk = "/share/work/user124/software/02.genome_assemble/sametools/GenomeAnalysisTK.jar";
my $bwaDir = "02.bwa";
my $gatk_dir = "03.gatk";
my $rm_dup_dir = "02.rmdup";
`mkdir $gatk_dir` if (! -e $gatk_dir);
`mkdir $bwaDir` if (! -e $bwaDir);
`mkdir $rm_dup_dir` if (! -e $rm_dup_dir);
foreach my $ip1 (@ip){
    my $ip2 = $ip1;
    my $prefix;
    if ($ip1 =~ /reads\/(.+)\.1.fq.gz/){
	$prefix = $1;
    }else{
	next();
    }
    print "$prefix\n";
    $ip2 =~ s/1.fq.gz/2.fq.gz/;
    print O "$bwa mem -t 12 -R \'\@RG\\tID:$prefix\\tSM:$prefix\\tLB:$prefix\' $ref $ip1 $ip2 | $samtools sort -O bam -T $bwaDir/$prefix -l 3 -o $bwaDir/$prefix.bam -\n";
    print O2 "$samtools rmdup $bwaDir/$prefix.bam $rm_dup_dir/$prefix.rmdup.bam;";
    print O2 "$samtools index $rm_dup_dir/$prefix.rmdup.bam\n";
    print O3 "$java -Xmx10g -jar $gatk -R $ref -T RealignerTargetCreator -o $gatk_dir/$prefix.intervals -I $rm_dup_dir/$prefix.rmdup.bam;$java -Xmx10g -jar $GATK -R $ref -T IndelRealigner -targetIntervals $gatk_dir/$prefix.intervals -o $gatk_dir/$prefix.realn.bam -I $rm_dup_dir/$prefix.rmdup.bam\n";
}

close O;
close O2;
close O3;
