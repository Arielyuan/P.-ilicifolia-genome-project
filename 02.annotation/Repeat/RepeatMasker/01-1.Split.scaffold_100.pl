#!/usr/bin/perl -w
#将基因组scaffold分成100条一个文件，并创建.sh文件，其中parallel和species可以根据需要改动
#input为基因组fasta文件
#$species为你需要设置的species参数
#$repeatmasker_path为软件repeatmasker的路径
use strict;
use Bio::SeqIO;
my $input=shift;
my $species='All';  
my $output_sh="02.Repeatmasker.split.sh";
open (O1,">$output_sh");

my $i=1;
my $repeatmasker_path="/share/work/user125/software/RepeatMasker/RepeatMasker/RepeatMasker";
if (!-e "scaffold.$i"){
    system "mkdir 'scaffold.$i'";
    my $output_scaffold="scaffold.$i/scaffold.$i.fa";
    open (O,">$output_scaffold");
#    my $repeatmasker_path="/share/work/user125/software/RepeatMasker/RepeatMasker/RepeatMasker";
    print O1 "$repeatmasker_path -nolow -no_is -norna -parallel 1 -species \"$species\" -gff $output_scaffold\n";
}else{
    print "scaffold.$i has already existed.Please check your directory!\n";
}

my $split_number=100;
my $fa=Bio::SeqIO->new(-file=>$input,-format=>'fasta');
while (my $seq_obj=$fa->next_seq){
    my $ID=$seq_obj->id;
    my $seq_name=$seq_obj->display_name;
    my $seq=$seq_obj->seq;
    if ($i%$split_number!=0){
	print O ">$seq_name\t$ID\n$seq\n";
    }else{
	print O ">$seq_name\t$ID\n$seq\n";
	close O;
	my $j=int($i/$split_number)+1;
	if (!-e "scaffold.$i"){
	    system "mkdir 'scaffold.$j'";
	    my $output_scaffold="scaffold.$j/scaffold.$j.fa";
#	    my $repeatmasker_path="/share/work/user125/software/RepeatMasker/RepeatMasker/RepeatMasker";
	    print O1 "$repeatmasker_path -nolow -no_is -norna -parallel 1 -species \"$species\" -gff $output_scaffold\n";
	    open (O,">$output_scaffold");
	}else{
	    print "The dirname scaffold.$i has already exists.Please check your directory!\n";
	}
   }
    $i++;
}
close O;
close O1;
