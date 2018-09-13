#!/usr/bin/perl -w
#此脚本用来将repeatproteinmasker输出文件装换成gff格式
use strict;
use Bio::SeqIO;
my %scaffold;
my ($scaffoldfile,$infile,$outfile)=@ARGV;#scaffol文件,.out文件输入,gff输出文件
die "$0 Usage:<scaffoldfile><infile><outfile>\n"if(@ARGV!=3);
my $mark=1000;#程序运行标记
my @arrayID;#scaffold中的ID
  
print"Loading $scaffoldfile.....\n";
my $fa=Bio::SeqIO->new(-file=>$scaffoldfile,-format=>'fasta');
while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    push(@arrayID,$id);
}#把scaffold中的scaffold编号按照顺序存储在@arrayID数组中
print"Loading $infile...\n";
my $IDnum=0;#将.out文件中的ID进行重新编号，产生唯一的键
open(F,"$infile");
<F>;
while(<F>){
    my $line=$_;
    chomp $line;
    my @array=split(/\s+/,$line);
    my $class=$array[8];
    unless($class eq "Simple_repeat"){                       #判断在class/family中是否有simple_repeat,有就删除
	my @scaffoldname=split(/\_/,$array[3]);                      #将scaffold的名字按照_分开，由于proteinmasker跑出来的结果中seqID的最大字节是18
	my $scaffoldID=$scaffoldname[0];
	$IDnum++;        
	$scaffold{$scaffoldID}{$IDnum}=$line;                #将.out的文件每一行写入到哈希中
    }
}
close F;

my $num=0;
my $zerolength=8;
my @arrayNUM=keys %scaffold;                                #第一层哈希键放到一个数组（也就是.out文件中的id列，重新修改过的）
print "writing $outfile.....\n";
open(O,">$outfile");
foreach my $scaffoldID(@arrayID){                             #按照scaffold编号顺序来查找
    my @scaffoldname=split(/\_/,$scaffoldID);
    my $purescaffold=$scaffoldname[0];
    if(exists $scaffold{$purescaffold}){
	my @arrayNUM=keys %{$scaffold{$purescaffold}};
	foreach my $arrayNUM(@arrayNUM){                        #遍历第一层哈希中的键
	    my @array=split(/\s+/,$scaffold{$purescaffold}{$arrayNUM});
	    $num++;
	    my $length=length $num;
	    my $zero=$zerolength-$length;
	    my $ID="0" x $zero . $num;
	    my $score=$array[1];my $seqstart=$array[4];my $seqend=$array[5];my $mark=$array[6];my $Target=$array[7];my $targetstart=$array[9];
	    my $targetend=$array[10];my $classfamily=$array[8];my $pValue=$array[0];
	    print O "$scaffoldID\tRepeatproteinMasker\tTEprotein\t$seqstart\t$seqend\t$score\t$mark\t\.\tID=TP$ID;Target=$Target ";
	    print O "$targetstart $targetend;class/family=$classfamily;pValue=$pValue;\n";
	    if($num%$mark==0){print"$num done!\n";}
	}
    }
}
close O;
