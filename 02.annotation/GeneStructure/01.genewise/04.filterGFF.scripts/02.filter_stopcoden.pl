#!/usr/bin/perl -w
#此脚本用于将上一步转成标准格式的gff文件，根据位置信息取出基因组中的序列，翻译后过滤中间有终止密码子的序列的信息，并将过滤好的gff文件输出，程序运行结束后会输出过滤掉的基因的个数
#基因组文件 标准gff文件 输出文件
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;
my $genomefile=shift;
my $standard_gff = shift;
my $op_filtered_gff = shift;

print STDERR "STEP1\n";

my $fa = Bio::SeqIO->new(-file=>$genomefile, -format=>'fasta');
my %dna;
my $minus_gene;
my $plus_gene;
my $wrong_gene = 0;
open (O,">$op_filtered_gff") or die("$!\n");

while(my $seq = $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    $dna{$id} = $seq;
}

print STDERR "STEP2\n";

my %hash;
open (F,"<$standard_gff") or die ("Cannot open $standard_gff!\n");
while (my $eve = <F>){
    chomp($eve);
    my $gene_name;
    my @infor = split/\t/,$eve;
    my $scaffold_name = $infor[0];
#genename:ID=ath-scaffold1003_cov113-1;
#genename:Parent=ath-scaffold1003_cov113-1;
    my $line_eight = $infor[8];
    if ($line_eight =~ /(\w+)\=(.+)/){
	$gene_name = $2;
    }
    my $strand = $infor[6];
    my $type = $infor[2];
    my $score = $infor[5];
    if(($strand eq "+") && ($type eq "mRNA")){
	$hash{$gene_name}{strand} = "plus";
	$hash{$gene_name}{gff}.= $eve."\n";
    }elsif (($strand eq "-") && ($type eq "mRNA")){
	$hash{$gene_name}{strand} = "minus";
	$hash{$gene_name}{gff}.= $eve."\n";
    }elsif ($type eq "CDS"){
	my $start = $infor[3];
	my $end = $infor[4];
	my $newcds = substr($dna{$scaffold_name},$start-1, $end-$start+1);
	$hash{$gene_name}{cds}.= $newcds;
	$hash{$gene_name}{gff}.= $eve."\n";
    }else{
	next;
    }
}
    
    
foreach my $gene_name (keys %hash){
    my $protein;
    if($hash{$gene_name}{strand} eq "plus"){
	$protein = translate_nucl($hash{$gene_name}{cds});
    }elsif($hash{$gene_name}{strand} eq "minus"){
	my $revcds = reverse ($hash{$gene_name}{cds});
	$revcds =~ tr/ACGTacgt/TGCAtgca/;
	$protein = translate_nucl($revcds);
    }else{print "wrong\n"; last;}
    my $protein_length = length ($protein);
    my $newprotein = substr($protein,0,$protein_length-1);
    if ($newprotein =~ /\*/){
	$wrong_gene += 1;
	next;
    }else{
	print O "$hash{$gene_name}{gff}"
    }
}
close F;

sub translate_nucl{
    my $seq=shift;
    my $seq_obj=Bio::Seq->new(-seq=>$seq,-alphabet=>'dna');
    my $pro=$seq_obj->translate;
    $pro=$pro->seq;
    return($pro);
}

close O;
print "$wrong_gene\n";
