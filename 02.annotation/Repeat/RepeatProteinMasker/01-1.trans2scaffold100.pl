#!/usr/bin/perl -w
#此脚本将scaffold文件进行拆分，拆分后每一份文件中包含scaffoldNUM个scaffold
use strict;
use Bio::SeqIO;
my $inputfile=shift;
my $scaffoldNUM=100;#一份文件中有几个scaffold
my $num=1;
my $filename;
my $O=1;
my $cds_obj=Bio::SeqIO->new(-file=>$inputfile,-format=>'fasta');
while(my $seq=$cds_obj->next_seq){
    my $id=$seq->id;    #获取fasta序列的基因名
    my $seq=$seq->seq;  #获取fasta序列的基因序列
    if($num%$scaffoldNUM==1){    
        `mkdir $O`;
        $filename=$O."/".$O.".fa";
        $O++;
    }
    open (O,">>$filename");
    print O ">$id\n$seq\n";
    close O;
    $num++;
}
