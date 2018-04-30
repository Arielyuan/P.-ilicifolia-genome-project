#!/usr/bin/perl -w
#这个脚本用来统计querry(转录组)有多少个基因，以及比对率为100%、90%、……50%等的基因有多少个。
use strict;
use Bio::SeqIO;

my $query = shift;
my $blat_out = shift;
my $output = shift;

open (F,"<$blat_out") or die ("$!\n");
open (O,">$output") or die ("$!\n");

my %query; #%query里面记录了每个query的长度和数量信息
my $query_num = 0; 
my $fa=Bio::SeqIO->new(-file=>$query,-format=>'fasta');
while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    my $single_length = length($seq);
    $query{$id} = $single_length;
    $query_num++;
}

#读blat的输出文件，提取相关信息
my %total_blast;#${total_blast}{$query_name}:存放每一个query的比对上的长度信息
my %total_blast_tmp; # 临时存放的一个hash记录一个query去冗余之后的长度
my $last_query_name = "Hello"; # 上一个query的名字
while (my $eve = <F>){
    chomp ($eve);
    my @a = split/\s+/,$eve;
#    my $scaffold_name = $a[1];
    my $query_name = $a[0];
    my $start = $a[6];  #$a[6]存放的是query的起始位置
    my $end = $a[7];  #$a[7]存放的是query的终止位置
    if($query_name ne $last_query_name && $last_query_name ne "Hello"){
        my $length = scalar (keys %total_blast_tmp);
        $total_blast{$last_query_name} = $length;
        %total_blast_tmp = ();
    }
    $last_query_name = $query_name;
    for (my $i=$start;$i<=$end;$i++){
        $total_blast_tmp{$i}++;
    }
}
my $length = scalar (keys %total_blast_tmp);
$total_blast{$last_query_name} = $length;

my %count;
my @i = (1,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5);
foreach my $query_name(sort keys %query){
    if (exists $total_blast{$query_name}){
	foreach my $i (@i){
	    if ($total_blast{$query_name}/$query{$query_name} >= 1*$i ){
		$count{$i}++;
	    }
	}
    }
}

print O "total_num\tlevel\tnum\tpercent\t\n";
foreach my $i (@i){
    my $percent = $count{$i}/$query_num;
    print O "$query_num\t$i\t$count{$i}\t$percent\t\n";
}
close F;
close O;
