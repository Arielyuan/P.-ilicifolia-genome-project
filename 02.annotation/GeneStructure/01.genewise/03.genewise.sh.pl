#!/usr/bin/perl -w
use strict;
my $dnafile = shift;
my @b2goutfile = @ARGV;
my $sh = "04-4.ptr.sh";
open (S,">$sh") || die ("Cannot create $sh!\n");

#提取dnafa里面的序列信息
use Bio::SeqIO;
my %dnahash;
my $fa = Bio::SeqIO->new(-file=>$dnafile, -format=>'fasta');
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq ->seq;
    my $length = length ($seq);
    $dnahash{$id} = $length;
}

#文件名为02-2.out.ath.2.bl2g
for (my $j=0;$j<@b2goutfile;$j++){
    my $name;
    my $num;
    if ($b2goutfile[$j] =~ /02-2\.out\.(\w+)\.(\d+)\.bl2g/){
	$name = $1;
	$num = $2;
    }else{
	print "match wrong!\n"
    }

#提取b2g里面的所有信息，包括起始结束位置，正负链，querry，scaffold等信息
    open (F,"<$b2goutfile[$j]") or die ("Cannot open $b2goutfile[$j]!\n");
    my $strend;
    my $start;
    my $end;
    my $newstart;
    my $newend;
    my $i = 1;
    while (my $eve1 = <F>){
	chomp($eve1);
	my @infor1 = split/\s+/,$eve1;
	my $cov = $infor1[2];
	if($eve1=~/^#GENE*/ && $cov>0.3){
	    my $position = $infor1[7];
	    if ($position =~ /\~\((\d+)\.\.(\d+)\)/){
		$strend = "minus";
		$start = $1;
		$end = $2;
	    }elsif ($position =~ /(\d+)\.\.(\d+)/){
		$strend = "plus";
		$start = $1;
		$end = $2;
	    }
	    my $eve2 = <F>;
	    my @infor2 = split/\s+/,$eve2;
	    my $query = $infor2[0];
	    my $scaffold = $infor2[1];
	    if ($start-1000 <= 0){
		$newstart = 1;
	    }else{
		$newstart = $start-1000;
	    }
	    if ($end+1000 >= $dnahash{$scaffold}){
		$newend = $dnahash{$scaffold};
	    }else{
		$newend = $end+1000;
	    }
	    if ($strend eq "plus"){
		print S "export WISECONFIGDIR=/home/user106/user124/software/03.gene_prediction/wise2.4.1/wisecfg/;/home/user106/user124/software/03.gene_prediction/wise2.4.1/src/bin/genewise 02.proteins/04.$name/\"$query.fa\" 01.pilscaffolds/$scaffold.fa -u $newstart -v $newend -pseudo -tfor -gff 1> 03.rawgff/04.$name.gff/$name$num.$i.gff 2> /dev/null\n";
	    }
	    elsif ($strend eq "minus"){
		print S "export WISECONFIGDIR=/home/user106/user124/software/03.gene_prediction/wise2.4.1/wisecfg/;/home/user106/user124/software/03.gene_prediction/wise2.4.1/src/bin/genewise 02.proteins/04.$name/\"$query.fa\" 01.pilscaffolds/$scaffold.fa -u $newstart -v $newend -pseudo -trev -gff 1> 03.rawgff/04.$name.gff/$name$num.$i.gff 2> /dev/null\n";
	    }
	    $i++;
	}
    }
    close F;
}
