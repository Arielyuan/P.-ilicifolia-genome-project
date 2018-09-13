#!/usr/bin/perl -w
#将基因组scaffold分成100条一个文件，并创建.sh文件，其中parallel和species可以根据需要改动
#文件输入顺序：$input为基因组fasta文件,$output_sh的文件名可改动
use strict;
use Bio::SeqIO;
my $input=shift;
my $output_sh="01.trf.sh";
open (O1,">$output_sh");

my $i=1;
system "mkdir 'scaffold.$i'";
if (!-e "scaffold.$i"){
    my $output_scaffold="scaffold.$i/scaffold.$i.fa";
    open (O,">$output_scaffold");
}else{
    print "scaffold.$i has already existed.Please change and check the dirname!\n";
}
my $trf_path="/share/work/user125/software/trf407b.64.linux64";
my $genome_fa="/share/work/user125/project/01.PopulusPruinosa.Genome/01.Assemble/04.SoapDenove_GapCloser/Soap_Gapclose.out/05.Scaffold.filter/scaffold_effective.filter.fa";
#基因组fasta文件可链接到01.TRF目录下
print O1 "$trf_path $genome_fa 2 7 7 80 10 50 2000 –d –h\n";
my $fa=Bio::SeqIO->new(-file=>$input,-format=>'fasta');
while (my $seq_obj=$fa->next_seq){
    my $ID=$seq_obj->id;
    my $seq_name=$seq_obj->display_name;
    my $seq=$seq_obj->seq;
    if ($i%100!=0){
        print O ">$seq_name\t$ID\n$seq\n";
    }else{
        print O ">$seq_name\t$ID\n$seq\n";
        close O;
        my $j=int($i/100)+1;
        system "mkdir 'scaffold.$j'";
        if (!-e "scaffold.$j"){
            my $output_scaffold="scaffold.$j/scaffold.$j.fa";
            print O1 "$trf_path $genome_fa 2 7 7 80 10 50 2000 –d –h\n";
            open (O,">$output_scaffold");
        }else {
            print "the dirname scaffold.$j has existed.Please check your directory!\n";
        }
    }
    $i++;
}
close O;
close O1;
