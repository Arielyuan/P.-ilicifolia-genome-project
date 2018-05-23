#!/usr/bin/perl -w 
use strict;

my $vcf = shift;
$vcf =~ /\/([^\/]+).vcf.gz/;
my $chr = $1;
my $op_vcf = "02.SNPbyChr/$chr/$chr.allsite.vcf.gz";
open (O,"|gzip -> $op_vcf") or die ("$!\n");

#读vcf文件，将物种信息存在%spe中，将有snp的位点信息存在%hash中
my %hash; #存的是snp的位点
my %indel; #存的是indel位点
if (-e $vcf){
    open (V,"zcat $vcf |") or die ("$!\n");
    while (my $eve = <V>){
	chomp ($eve);
	if($eve =~ /^##/){
	    print O "$eve\n";
	}elsif($eve =~ /^#/){
	    print O "$eve\n";
	}else{
	    my @a=split(/\s+/,$eve);
	    my $chr_id = $a[0];
	    my $pos = $a[1];
	    my $ref = $a[3];
	    my $alt = $a[4];
	    next if ($alt=~ /,/);
	    print "$ref\t$alt\n";
	    if (length($alt) != length ($ref)){
		for (my $i=$pos-5;$i<=$pos+5;$i++){
		    $indel{$chr_id}{$i}++;
		}
	    }
	    $hash{$chr_id}{$pos} = $eve;
	}
    }
    close V;
}

#跑bam文件需要的命令
my %spe;
my $bam_list = "bam.list";
open (L,"<$bam_list") or die ("$!\n");
my $rank_bam;
my $j=9;
while (my $eve = <L>){
    chomp($eve);
    $rank_bam .= "$eve"." ";
    #03.gatk/PPr10.realn.bam
    $eve =~ /01.bam\/(.+).realn.bam/;
    my $ind = $1;
    $spe{$j} = $ind;
    $j++;
}
$rank_bam =~ s/\s+$//; #这里bam的个体顺序与vcf里面是一致的
close L;


my $depth_file = "01.bam/01.ptr.depth.count";
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
close F;
    
#读depth文件，共有位点的非snp的信息，生成新的vcf  
open (D,"/home/software/samtools/samtools-1.2/samtools depth -r $chr $rank_bam |") or die ("$!\n");
while (my $eve = <D>){
    chomp($eve);
    my @b = split /\s+/,$eve;
    my $chr_id = $b[0];
    my $pos = $b[1];
    my $length = scalar (@b);
    next if (exists $indel{$chr_id}{$pos});
    if (exists $hash{$chr_id}{$pos}){
	print O "$hash{$chr_id}{$pos}\n";
    }else{
	my @c;
	for (my $i=2;$i<$length;$i++){
	    my $haplotype;
	    my $vcf_id = $i+7;
	    my $ind = $spe{$vcf_id};
	    my $mean = $depth{$ind};
	    my $min=$mean/3;
	    if($min < 2){
		$min=2;
	    }
	    if (($b[$i]<$min) || ($b[$i]>($mean*3))){
		$haplotype = "./.";
	    }else{
		$haplotype = "0/0";
	    }
	    push (@c,$haplotype);
	}
	my $nine = join("\t",@c);
	print O "$chr_id\t$pos\t.\t.\t.\t.\t.\t.\t.\t$nine\n";
    }
}


close D;
close O;
