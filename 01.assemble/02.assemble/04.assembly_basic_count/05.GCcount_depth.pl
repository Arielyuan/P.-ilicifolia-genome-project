#!/usr/bin/perl -w
#此脚本用来统计每个窗口中GC含量和平均深度，$Winnum可以调整窗口的大小，$path需要改成自己的samtools的路径
#依次输入：脚本路径 基因组的fasta文件 samtools跑出来的bam文件 输出文件
use strict;
use Bio::SeqIO;
my $fasta = shift;
my $bam = shift;
my $op = shift;
my $samtools_path = "/share/work/user124/software/02.genome_assemble/sametools/samtools/samtools";
my $WinNum = 20000;
open (O ,">$op") or die ("$!/n");
print O "Scaffold_name\tposition\tNnum\tGC\tDepth\n";
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
            my $GC=($newseq=~tr/[G|g|C|c]//);
            my $GCcount = $GC/($WinNum-$N);
            $hash{$id}{$i}{ATGC} = $WinNum-$N;
            $hash{$id}{$i}{GCcount} = $GCcount;
            $hash{$id}{$i}{depth} = 0;
        }
        $i+=$WinNum;
    }
    open (I,"$path depth -r $id $bam |");
    while(my $eve = <I>){
        chomp ($eve);
        my @infor = split/\t/,$eve;
        my $scaffold_name = $infor[0];
        my $position =(int ($infor[1]/$WinNum))*$WinNum + 1;
        my $depth = $infor[2];
        if(!exists $hash{$scaffold_name}{$position}){
            next;
        }
        $hash{$scaffold_name}{$position}{depth} += $depth;
    }
    close I;
}

foreach my $id (sort keys %hash){
    foreach my $i (sort {$a <=> $b} keys %{$hash{$id}}){
        if(!$hash{$id}{$i}{ATGC}){
            $hash{$id}{$i}{ATGC}="NA";
        }
        if(!$hash{$id}{$i}{GCcount}){
            $hash{$id}{$i}{GCcount}="NGC";
        }
        if(!$hash{$id}{$i}{depth}){
            $hash{$id}{$i}{depth}=0;
        }
        my $evedepth=($hash{$id}{$i}{depth})/($hash{$id}{$i}{ATGC});
        print O "$id\t$i\t$hash{$id}{$i}{ATGC}\t$hash{$id}{$i}{GCcount}\t$hash{$id}{$i}{depth}\t$evedepth\t\n";
    }
}
close O;
