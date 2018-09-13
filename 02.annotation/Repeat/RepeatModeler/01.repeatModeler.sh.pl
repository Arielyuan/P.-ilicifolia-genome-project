#!usr/bin/perl -w
#生成运行repeatmodeler的命令的sh文件
#注意consensi.fa.classified文件路径需设置为你自己classified文件的路径
use strict;
use Bio::SeqIO;
my $output_sh="04.Repeatmodeler.sh";
open (O,">$output_sh");
my $scaffold_dir="scaffold_100.dir";
my @files=<$scaffold_dir/*>;
my $perl5_path="PERL5LIB=\$PERL5LIB:/share/work/user125/perl5/lib/perl5";
my $repeatmasker_path="/share/work/user125/software/RepeatMasker/RepeatMasker/RepeatMasker";
my $classified_path="../04.RepeatModeler/RM_38944.WedNov181121392015/consensi.fa.classified";

for (my $i=1;$i<=@files-1;$i++){
    my $output_Sca="scaffold.$i";
    my $output_fa="scaffold.$i.fa";
    print O "export $perl5_path;$repeatmasker_path -parallel 10 -lib $classified_path $output_Sca/$output_fa\n";
}
close O;
