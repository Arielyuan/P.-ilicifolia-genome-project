#!/usr/bin/perl -w
use strict;
my @file = @ARGV;

for (my $j=0;$j<@file;$j++){
# 文件名为 01.tbnout.ath.1
    # print "$file[$j]\n";
    if($file[$j]=~/01.tbnout\.(\w+)\.(\d+)/){
	my $name = $1;
	my $out = $2;
	my $sh = "02."."b2g".$1.".sh";
	open (S,">>$sh") ||die ("$!\n");
	print S "/home/user106/user124/software/03.gene_prediction/blast.parse.pl $file[$j] 02-1.out.$name.$out.bp;/home/user106/user124/software/03.gene_prediction/blast2gene.pl 02-1.out.$name.$out.bp > 02-2.out.$name.$out.bl2g\n";
    }else{
	print "no suit files\n";
	last;
    }
}
