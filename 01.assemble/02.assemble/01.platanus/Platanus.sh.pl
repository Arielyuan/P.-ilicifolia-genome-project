#!/usr/bin/perl -w
use strict;
#此脚本用于生成platanus：assemble、scaffold、gap_close三个流程的sh文件，使用时要修改第一部分的内容；
#给了reads的目录，可以自动匹配目录下的reads,但是注意，reads的命名，以fa.gz结尾，短片段的reads如：pil.500bp.1.fq.gz;长片段的reads如：pil.2kbp.1.fq.gz

my $platanus_path = "/home/user101/software/platanus/platanus";
my $reads_path = "../01.CleanReads";
my $proc = "50";
my $mem = "500";
my $o1 = "01.contig";
my $o2 = "02.scaffold";
my $o3 = "03.platanusGapClose";

my $sh1 = $o1 .".sh";
my $sh2 = $o2 .".sh";
my $sh3 = $o3 .".sh";
open (S1,">$sh1") or die ("$!/n");
open (S2,">$sh2") or die ("$!/n");
open (S3,">$sh3") or die ("$!/n");
print S1 "$platanus_path assemble -o $o1 -t $proc -m $mem ";
print S2 "$platanus_path scaffold -o $o2 -b $o1"."_contigBubble.fa -c $o1"."_contig.fa -t $proc ";
print S3 "$platanus_path gap_close -o $o3 -c $o2"."_scaffold.fa -o $o3 -t $proc ";
opendir (DIR, '.') or die ("Couldn't open directory, $!");
my %hash;
my $file2;
while (my $file = readdir DIR){
#Populus_ilicifolia.800bp.2.fq.gz
    chomp ($file);
    if ($file =~/(\w+)\.(\d+)bp\.1\.fq$/ || $file =~/(\w+)\.(\d+)bp\.1\.fq.gz$/){
	my $insertsize=$2;
	($file2 = $file) =~ s/1\.fq/2\.fq/; 
	if (-e $file2){
	    $hash{$insertsize} = $file;
	}else{
	    print "Not paired reads!\n";
	}	
    }elsif($file =~/(\w+)\.(\d+)kbp\.1\.fq$/ || $file =~/(\w+)\.(\d+)kbp\.1\.fq.gz$/){
	my $insertsize=$2*1000;
	($file2 = $file) =~ s/1\.fq/2\.fq/;
	if (-e $file2){
            $hash{$insertsize} = $file;
        }else{
            print "Not paired reads!\n";
        }
    }
}
closedir DIR;

my $i=1;
foreach my $insertsize (sort {$a <=> $b} keys %hash){
    (my $pairedfile = $hash{$insertsize}) =~ s/1.fq/2.fq/;
    if ($insertsize < 2000){
	print S1 "-f $reads_path/$hash{$insertsize} $reads_path/$pairedfile ";
	print S2 "-IP$i $reads_path/$hash{$insertsize} $reads_path/$pairedfile ";
	print S3 "-IP$i $reads_path/$hash{$insertsize} $reads_path/$pairedfile ";
    }else{
	print S2 "-OP$i $reads_path/$hash{$insertsize} $reads_path/$pairedfile ";
	print S3 "-OP$i $reads_path/$hash{$insertsize} $reads_path/$pairedfile ";
    }
    $i++;
}
