#!/usr/bin/perl -w 
#此脚本可以实现的功能有：1,将blast2gene输出的所有gff文件整合到一起;2,整合的gff里面负链的start与end顺序调整，调整后的所有行都是start<end;3,最后一列调整为gff3格式(ID= Parent=),并为每一个基因编一个特定的ID;4,将genewise输出的的match换成mRNA,cds换成CDS;5,每个基因按照cds从小到大的顺序输出;
#输出文件 输入的gff文件的目录
#使用时一定要将$species换成当前物种的名字！！
use strict;
my $i=0;
my $op_gff = shift;
my $gff_dir=shift;
my $species = "ath";
my @gff_file = <$gff_dir/*>;
my $gene_id;
open (O,">$op_gff") or die ("$!\n");
my %hash;
for (my $j=0;$j<@gff_file;$j++){
    open (F,"<$gff_file[$j]") or die ("$!\n");
    while(my $eve = <F>){
	if ($eve =~ /^\w/){
	    my @infor = split /\s+/,$eve;
	    my $type = $infor[2];
	    my $scaffold_name = $infor[0];
	    if ($infor[2] eq "match"){
		$i++;
		$infor[2] = "mRNA";
		$gene_id = "ID=".$species."-".$scaffold_name."-".$i;
	    }elsif ($infor[2] eq "cds"){
		$infor[2]="CDS";
		$gene_id = "Parent=".$species."-".$scaffold_name."-".$i;
	    }elsif ($infor[2] eq "mRNA"){
		$i++;
		$gene_id = "ID=".$species."-".$scaffold_name."-".$i;
	    }elsif ($infor[2] eq "CDS"){
		$gene_id = "Parent=".$species."-".$scaffold_name."-".$i;
	    }
	    if(scalar(@infor)!=9){
		print STDERR "@infor\n";
	    }
	    $infor[8]=$gene_id;
	    if($infor[6] eq "-"){
		my $temp=$infor[4];
		$infor[4]=$infor[3];
		$infor[3]=$temp;
	    }
	    my $neweve = join "\t", @infor;
	    my $key = $species."-".$scaffold_name."-".$i;
	    if($infor[2] eq "mRNA"){
		$hash{$key}{mRNA} = $neweve.";\n";
	    }elsif($infor[2] eq "CDS"){
		$hash{$key}{CDS}{$infor[3]} = $neweve.";\n";
	    }
	}else{
	    next;
	}
    }
    if($j % 1000 == 0){
        print STDERR "$j complete!\n";
    }
}
foreach my $gene(sort keys %hash){
    print O "$hash{$gene}{mRNA}";
    foreach my $start (sort {$a<=>$b} keys %{$hash{$gene}{CDS}}){
	print O "$hash{$gene}{CDS}{$start}";
    }
}
close F;
close O;
