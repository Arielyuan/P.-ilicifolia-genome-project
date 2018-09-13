#!usr/bin/perl -w
#生成运行repeatmasker的命令的sh文件,如果01.split_scaffold脚本生成的sh有问题，可用这个脚本重新生成sh文件
#注意-species得设置
use strict;
use Bio::SeqIO;
my $output_sh="02.repeatmasker.run.sh";
open (O,">$output_sh");
my $scaffold_dir="scaffold_100.dir";
my @files=<$scaffold_dir/*>;
my $perl5_path="PERL5LIB=$PERL5LIB:/share/work/user125/perl5/lib/perl5";
my $repeatmasker_path="/share/work/user125/software/RepeatMasker/RepeatMasker/RepeatMasker";
my $species="All";
for (my $i=1;$i<=@files-1;$i++){
    my $output_dir="scaffold.$i";
    my $output_Sca="scaffold.$i/scaffold.$i.fa";
    my $output_simple="scaffold.$i.out.simple";
    print O "export $perl5_path;$repeatmasker_path -nolow -no_is -norna -parallel 2 -species \"$species\" -gff $output_Sca\n"; 
}
close O;
