#!/usr/bin/perl -w
#统计基因组GC含量分布，将组装的基因组以500bp为窗口，计算每个窗口的GC含量
#脚本路径，基因组fasta文件 输出文件
use strict;
use Bio::SeqIO;
my $winnum=500;
my $file = shift;
my $op = shift;
open (O ,">$op") or die ("$!/n");
print O "Scaffold_name\tposition\tNnum\tGC\t\n";
my %hash;
my $position;
my $i=0;
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');

while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    for (my $start = 0;$start < length ($seq)-($winnum-1); $start += $winnum){
	my $newseq = substr ($seq,$start,$winnum);
	my $N = ($newseq=~tr/[N|n]//);
	if($N<=($winnum*0.5)){
	    $i++;
	    my $GC=($newseq=~tr/[G|g|C|c]//);
	    my $GCcount = $GC/($winnum-$N);
	    print O "$id\t$i\t$N\t$GCcount\n";
	}
    }
}
