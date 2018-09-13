#!/usr/bin/perl -w
#此脚本用于统计每个窗口中SNP的密度情况，筛选位点时有以下几个条件：1.舍弃质量值小于30的位点 2.舍弃覆盖度小于5，或大于平均覆盖度5倍的位点；会输出两个文件，一是有关snp的统计信息，一是过滤后的vcf文件，其中，snp统计是不包括基因型为1/1的位点，而过滤后的vcf文件包括基因型为1/1的位点
#可以修改12行变量窗口大小（$WinNum)
#脚本路径 基因组fasta文件 vcf文件 04-3输出的averge_depth_file 输出文件1（有关snp信息的文件） 输出文件2（过滤后的vcf文件）
use strict;
use Bio::SeqIO;
my $fasta = shift;
my $vcf_file = shift;
my $averge_depth_file = shift;
my $op = shift;
my $filter_vcf = shift;
my $WinNum = 20000;
open (F,"<$vcf_file") || die ("$!/n");
open (A,"<$averge_depth_file") || die ("$!/n");
open (O ,">$op") or die ("$!/n");
open (V,">$filter_vcf") or die ("$!/n");
print O "Scaffold_name\tPosition\tATGC\tSNPnum\tPercent\n";

#从脚本04-3.eve_depth.pl生成的genome_average_depth.txt中读取基因组的平均深度
my $evedepth = <A>;
chomp ($evedepth);
close A;

#读fasta文件分成每一个Windows
my %hash;
my $fa = Bio::SeqIO->new(-file=>$fasta, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $len = length($seq);
    my $i=1;
    for (my $start = 0;$start < (length ($seq)-($WinNum-1)); $start += $WinNum){
        my $newseq = substr ($seq,$start,$WinNum);
        my $N = ($newseq=~tr/[N|n]//);
        if($N<=($WinNum*0.5)){
            $hash{$id}{$i}{ATGC} = $WinNum-$N;
            $hash{$id}{$i}{SNPnum} = 0;
        }
        $i+=$WinNum;
    }
}
#读vcf文件取出所有需要的信息
while (my $eve = <F>){
    chomp ($eve);
    if ($eve=~/^[^#]/){
        my @infor = split/\t/,$eve;
        my $seqname = $infor[0];
        my $position =(int ($infor[1]/$WinNum))*$WinNum + 1;
        my $quality = $infor[5];
        my @seven = split/;/,$infor[7];
        my $indel = $seven[0];
        my @nine = split/:/,$infor[9];
        my $gt = $nine[0];
        my @dp4 = split/,/,$nine[3];
        my $coverage = $dp4[0]+$dp4[1]+$dp4[2]+$dp4[3];
        #进行条件判断,把符合条件的存入对应的窗口中
        if (($quality <30) || ($indel=~/INDEL/) || ($coverage<5) ||($coverage>(5*$evedepth))){
            next;
        }
        elsif ($gt eq "1/1"){
            print V "$eve\n";
        }
        elsif(!exists $hash{$seqname}{$position}){
            next;
        }
        else{
            print V "$eve\n";
            $hash{$seqname}{$position}{SNPnum} ++;
        }
    }
}
    foreach my $id (sort keys %hash){
    foreach my $i (sort {$a <=> $b} keys %{$hash{$id}}){
        if(!$hash{$id}{$i}{ATGC}){
            $hash{$id}{$i}{ATGC}="NA";
        }
        if(!$hash{$id}{$i}{SNPnum}){
            $hash{$id}{$i}{SNPnum}=0;
        }
        my $percent=($hash{$id}{$i}{SNPnum})/($hash{$id}{$i}{ATGC});
        print O "$id\t$i\t$hash{$id}{$i}{ATGC}\t$hash{$id}{$i}{SNPnum}\t$percent\t\n";
    }
}
close O;
close F;
close V;
