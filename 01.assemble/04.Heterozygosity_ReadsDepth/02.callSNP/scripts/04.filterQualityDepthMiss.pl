#!/usr/bin/perl -w
use strict;
#此脚本用来过滤覆盖度不在min_depth(1/3*mean_depth)和max_depth(3*mean_depth)之间的情况，以及质量值小于30的情况，并将他们的单倍型做一个替换，如果有效的信息（miss）小于个体数的一半（50%），就把这个位点去掉。
#这个脚本不过滤indel，用在上一个补充了所有位点，并将indel前后5bp的位点去掉的脚本之后
#mean_depth 为每个个体的平均深度

#存入所有个体的depth信息
my $depth_file = shift;
open (F,"<$depth_file") || die ("$!/n");
my %depth;
while (my $eve = <F>){
    chomp($eve);
    next if ($eve =~ /^id/);
    my @a = split /\s+/,$eve;
    my $ind =$a[0];
    my $total_depth = $a[1];
    my $efficient_num = $a[2];
    $depth{$ind} = $total_depth/$efficient_num;
}

##处理vcf文件
my $vcf = shift;
$vcf =~ /\/([^\/]+).allsite.vcf.gz/;
my $chr = $1;
my $op_vcf = "02.SNPbyChr/$chr/$chr.fQC.vcf.gz";
open (O,"|gzip -> $op_vcf") or die ("$!\n");
open (V,"zcat $vcf|") or die ("$!/n");

my %hash;
while (my $eve = <V>){
    chomp ($eve);
    if($eve =~ /^##/){
        print O "$eve\n";
    }elsif($eve =~ /^#/){
        print O "$eve\n";
	my @a=split(/\s+/,$eve);
        my $length = scalar (@a);
        for (my $i=9;$i<$length;$i++){
            $hash{$i} = $a[$i];
        }
    }else{
        my @a=split(/\s+/,$eve);
	next if ($a[4] =~ /,/);
	my $quality = $a[5];
	my $length = scalar (@a);
	my $miss_num=0;
	for (my $i=9;$i<$length;$i++){
	    # 0/0:12,0:12:36:0,36,540
	    if($a[$i] =~/([^\:]+):[^\:]+:(\d+):[^\:]+:[^\:]+/){
		my ($gt,$dp)=($1,$2);
		my $mean = $depth{$hash{$i}};
		if (!exists $depth{$hash{$i}}){
		    print "$hash{$i}:\n$eve\n";
		}
		my $min=$mean/3;
		if($min < 2){
		    $min=2;
		}
		if (($quality<30) || ($dp<$min) || ($dp>($mean*3))){
		    $a[$i] = "./.";
		}
	    }
	    if ($a[$i] eq "./."){
		$miss_num++;
	    }
	}
	#print "$a[0]\t$a[1]\t$miss_num\n";
	next if ($miss_num >0.5*($length-9));
	my $neweve = join "\t",@a;
	print O "$neweve\n";
    }
}


close O;
close F;
close V;
