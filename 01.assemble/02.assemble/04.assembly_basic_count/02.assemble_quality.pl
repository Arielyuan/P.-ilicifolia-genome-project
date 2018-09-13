#! /usr/bin/perl -w
#统计N的含量，contig以及scaffoldN50，60，10，80，90等信息
#脚本路径，fasta文件，输出文件
use strict;
use Bio::SeqIO;
my $file=shift;
my $op=shift;
open (O,">$op")||die("$!\n");
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
my $total_scaffold_length=0;
my $total_contig_length=0;
my $N=0;
my $GC=0;
my $contig_num=0;
my $scaffold_num=0;
my @scaffold_length;
my @contig_length;
my $N_open_scaffold_number=0;

while(my $seq= $fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    #统计N值,GC含量
    $N+=($seq=~tr/[N|n]//);
    $GC+=($seq=~tr/[G|g|C|c]//);

    #得到scaffold长度的数组
    my $scaffold_length=length $seq;
    if($seq=~/^[Nn]/){
     $N_open_scaffold_number++;
    # print"the N open scaffold number is $N_open_scaffold_number\n";
    }
    $total_scaffold_length+=$scaffold_length;
    push(@scaffold_length,$scaffold_length);


    #得到contig长度的数组
    my @contig=split(/[Nn]+/,$seq);
    foreach my $_(@contig){
        $contig_num++;
        my $contig_length=length $_;
        $total_contig_length+=$contig_length;
        if ($contig_length!=0){
           push(@contig_length,$contig_length);
        }
    }
    print STDERR " [ $id loaded.. ] \r";
}

#得到scaffold的信息
my @s_scaffold_length =sort { $b <=> $a } @scaffold_length;
$scaffold_num=$#s_scaffold_length+1;
for(my $n1=50;$n1<=90;$n1=$n1+10){
    my $accum1=0;
    my $Nx_num=0;
    my $Nx_length=0;
    for (my $j=0;$j<@s_scaffold_length;$j++){
        $accum1+=$s_scaffold_length[$j];
        if (($accum1>=$total_scaffold_length*$n1/100)){
            my $R1=$s_scaffold_length[$j];
	    $Nx_length = $R1;
            print O "scaffold N$n1 is $R1\n";
            last;
        }
    }
    for (my $j=0;$j<@s_scaffold_length;$j++){
	if ($s_scaffold_length[$j]>=$Nx_length){
	    $Nx_num++;
	}
    }
    print O "scaffold N$n1 num is $Nx_num\n";
}

#得到contig的信息
my @s_contig_length =sort { $b <=> $a } @contig_length;
for(my $n2=50;$n2<=90;$n2=$n2+10){
    my $accum2=0;
    my $Nx_num=0;
    my $Nx_length=0;
    for (my $j=0;$j<@s_contig_length;$j++){
        $accum2+=$s_contig_length[$j];
        if (($accum2>=$total_contig_length*$n2/100)){
            my $R2=$s_contig_length[$j];
	    $Nx_length = $R2;
            print O "contig N$n2 is $R2\n";
            last;
        }
    }
    for (my $j=0;$j<@s_contig_length;$j++){
	if ($s_contig_length[$j]>=$Nx_length){
	    $Nx_num++;
	}
    }
    print O "contig N$n2 num is $Nx_num\n";
}
my $GC_contant=$GC/$total_contig_length;
print O "GCcontant\tN_number\n";
print O "$GC_contant\t$N\n";
print O "ContigLength\tContigNumber\tLongestContig\tSortestContig\n";
print O "$total_contig_length\t$contig_num\t$s_contig_length[0]\t$s_contig_length[-1]\n";
print O "ScaffoldLength\tScaffoldNumber\tLongestScaffold\tShortestScaffold\n";
print O "$total_scaffold_length\t$scaffold_num\t$s_scaffold_length[0]\t$s_scaffold_length[-1]\n";
close O;
